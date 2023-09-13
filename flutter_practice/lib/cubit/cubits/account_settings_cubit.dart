import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/misc/injection_configurator.dart';
import 'package:flutter_practice/services/comments_service.dart';
import 'package:flutter_practice/services/user_service.dart';
import 'package:get/get.dart';

import '../../misc/constants.dart';
import '../../misc/user_info.dart';
import '../../repository/models/user_model.dart';
import '../../services/authorization_service.dart';
import '../states/account_settings_state.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  final _authorizationService = getIt<AuthorizationService>();
  final _commentsService = getIt<CommentsService>();
  final _userService = getIt<UserService>();

  AccountSettingsCubit() : super(InitialAccountSettingsState());

  Future logout() async {
    await _authorizationService.logout();
  }

  UserModel getCurrentUserData() => UserInfo.loggedInUser!;

  Future deleteAccount() async {
    var deleteResult = await _userService.deleteUser(UserInfo.loggedInUser!);

    if (deleteResult.isSucceed) {
      await logout();
    } else {
      emit(ErrorAccountSettingsState(
          errorMesage: 'systemErrorPleaseContactUs'.tr));
    }
  }

  Future<bool> saveNewUserInfo(String newUsername, String newEmail,
      String oldPassword, String newPassword, String confirmNewPassword) async {
    bool isDataSaved = false;

    if (_validateInputData(
        newUsername, newEmail, oldPassword, newPassword, confirmNewPassword)) {
      final isEmailChanged = newEmail != UserInfo.loggedInUser!.email;
      final isUsernameChanged = newUsername != UserInfo.loggedInUser!.username;
      final isPasswordChanged = (newPassword.isNotEmpty &&
          newPassword != UserInfo.loggedInUser!.password);

      if (isEmailChanged || isUsernameChanged || isPasswordChanged) {
        final existUserResult = await _userService.getUserByEmail(newEmail);

        if (isEmailChanged && existUserResult.hasResult) {
          emit(ErrorAccountSettingsState(errorMesage: 'emailExistError'.tr));
        } else if (existUserResult.isSucceed) {
          var updatedUser = UserInfo.loggedInUser!;

          updatedUser.email = newEmail;
          updatedUser.username = newUsername;

          if (newPassword.isNotEmpty) {
            updatedUser.password = newPassword;
          }

          var updateResult = await _userService.updateUser(updatedUser);

          if (updateResult.isSucceed) {
            UserInfo.loggedInUser!.email = newEmail;
            UserInfo.loggedInUser!.username = newUsername;

            if (newPassword.isNotEmpty) {
              UserInfo.loggedInUser!.password = newPassword;
            }

            if (isUsernameChanged) {
              await _commentsService.updateCommentsOwnerName(
                  newUsername, updatedUser.id!);
            }

            isDataSaved = true;
          } else {
            emit(ErrorAccountSettingsState(
                errorMesage: 'systemErrorPleaseContactUs'.tr));
          }
        } else {
          emit(ErrorAccountSettingsState(
              errorMesage: 'systemErrorPleaseContactUs'.tr));
        }
      }
    }

    return isDataSaved;
  }

  bool _validateInputData(String username, String email, String oldPassword,
      String newPassword, String confirmNewPassword) {
    var isValid = true;
    String? errorText;

    if (username.isEmpty) {
      errorText = 'emptyUsernameError'.tr;
    } else if (!EmailValidator.validate(email)) {
      errorText = 'emailNotValidError'.tr;
    } else if (oldPassword.isNotEmpty ||
        newPassword.isNotEmpty ||
        confirmNewPassword.isNotEmpty) {
      if (oldPassword != UserInfo.loggedInUser?.password) {
        errorText = "Incorrect old password";
      } else if (!RegExp(Constants.passwordRegex).hasMatch(newPassword)) {
        errorText = 'weekPasswordError'.tr;
      } else if (newPassword != confirmNewPassword) {
        errorText = 'notMatchPasswordError'.tr;
      }
    }

    isValid = errorText == null;

    if (!isValid) {
      emit(ErrorAccountSettingsState(errorMesage: errorText));
    }

    return isValid;
  }
}
