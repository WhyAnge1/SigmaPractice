import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../misc/constants.dart';
import '../../misc/user_info.dart';
import '../../repository/models/user_model.dart';
import '../../repository/repositories/database.dart';
import '../states/account_settings_state.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  AccountSettingsCubit() : super(AccountSettingsState());

  Future<bool> logout() async {
    final prefferences = await SharedPreferences.getInstance();
    prefferences.remove(Constants.autoLoginEmailPreffName);
    UserInfo.clearLoggedInUser();

    return true;
  }

  UserModel getCurrentUserData() => UserInfo.loggedInUser!;

  Future<bool> saveNewUserInfo(String newUsername, String newEmail,
      String oldPassword, String newPassword, String confirmNewPassword) async {
    MobileDatabase? database;
    bool isDataSaved = false;

    if (validateInputData(
        newUsername, newEmail, oldPassword, newPassword, confirmNewPassword)) {
      final isEmailChanged = newEmail != UserInfo.loggedInUser!.email;
      final isUsernameChanged = newUsername != UserInfo.loggedInUser!.username;
      final isPasswordChanged = (newPassword.isNotEmpty &&
          newPassword != UserInfo.loggedInUser!.password);

      if (isEmailChanged || isUsernameChanged || isPasswordChanged) {
        try {
          database = await $FloorMobileDatabase
              .databaseBuilder(Constants.databaseFileName)
              .build();

          final existUser = await database.userDao.findUserByEmail(newEmail);
          if (isEmailChanged && existUser != null) {
            _emit(errorText: 'emailExistError'.tr);
          } else {
            await database.userDao.updateUser(UserInfo.loggedInUser!);

            if (isUsernameChanged) {
              await database.commentDao.updateCommentsOwnerName(
                  newUsername, UserInfo.loggedInUser!.id!);
            }

            UserInfo.loggedInUser!.email = newEmail;
            UserInfo.loggedInUser!.username = newUsername;

            if (newPassword.isNotEmpty) {
              UserInfo.loggedInUser!.password = newPassword;
            }

            isDataSaved = true;
          }
        } catch (ex) {
          _emit(errorText: 'systemErrorPleaseContactUs'.tr);
        } finally {
          database?.close();
        }
      }
    }

    return isDataSaved;
  }

  bool validateInputData(String username, String email, String oldPassword,
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
      _emit(errorText: errorText);
    }

    return isValid;
  }

  Future deleteAccount() async {
    MobileDatabase? database;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      await database.userDao.deleteUser(UserInfo.loggedInUser!);

      await logout();
    } catch (ex) {
      _emit(errorText: 'systemErrorPleaseContactUs'.tr);
    } finally {
      database?.close();
    }
  }

  void _emit({String? errorText}) =>
      emit(AccountSettingsState(errorText: errorText));
}
