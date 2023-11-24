import 'package:email_validator/email_validator.dart';
import 'package:event_bus_plus/res/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/event_bus_events/open_drawer_event.dart';
import 'package:flutter_practice/misc/injection_configurator.dart';
import 'package:flutter_practice/services/comments_service.dart';
import 'package:flutter_practice/services/user_service.dart';
import 'package:flutter_practice/ui/pages/login_page.dart';
import 'package:get/get.dart';

import '../../misc/constants.dart';
import '../../services/authorization_service.dart';
import '../states/account_settings_state.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  final _authorizationService = getIt<AuthorizationService>();
  final _commentsService = getIt<CommentsService>();
  final _userService = getIt<UserService>();
  final _eventBus = getIt<EventBus>();

  AccountSettingsCubit() : super(InitialAccountSettingsState());

  Future logout() async {
    await _authorizationService.logout();

    await Get.offAll(const LoginPage());
  }

  Future loadCurrentUserData() async {
    var user = _userService.currentLoggedInUser;
    var reloadResult = await _userService.reloadUser();

    if (reloadResult.isSucceed && user != null) {
      emit(DefaultUserDataAccountSettingsState(
          username: user.displayName ?? "", email: user.email!));
    } else {
      emit(ErrorAccountSettingsState(
          errorMesage: 'userNotFoundPleaseReloginAgain'.tr));

      await logout();
    }
  }

  void sendOpenDrawerEvent() {
    _eventBus.fire(OpenDrawerEvent());
  }

  Future deleteAccount(String password) async {
    if (password.isEmpty) {
      emit(ErrorAccountSettingsState(
          errorMesage: 'enterYourCurrentPasswordToDeleteYourAccount'.tr));

      return;
    }

    var deleteResult = await _userService.deleteCurrentUser(password);

    if (deleteResult.isSucceed) {
      await logout();
    } else {
      emit(ErrorAccountSettingsState(
          errorMesage: 'systemErrorPleaseContactUs'.tr));
    }
  }

  Future saveNewUserInfo(String newUsername, String newEmail,
      String oldPassword, String newPassword, String confirmNewPassword) async {
    var isUsernameChanged = await tryChangeUsername(newUsername);
    await tryChangeEmail(newEmail, oldPassword);
    var isPasswordChanged =
        await tryChangePassword(newPassword, confirmNewPassword, oldPassword);

    if (isUsernameChanged || isPasswordChanged) {
      emit(ShowInfoAccountSettingsState(
          infoMessage: 'newDataSavedSuccessfully'.tr));
    }
  }

  Future tryChangeEmail(String newEmail, String password) async {
    var user = _userService.currentLoggedInUser;

    if (newEmail == user?.email) {
      return;
    } else if (!EmailValidator.validate(newEmail)) {
      emit(ErrorAccountSettingsState(errorMesage: 'emailNotValidError'.tr));

      return;
    } else if (password.isEmpty) {
      emit(ErrorAccountSettingsState(
          errorMesage: 'enterYourCurrentPasswordToChangeYourEmail'.tr));

      return;
    }

    var updateResult = await _userService.updateUserEmail(newEmail, password);
    if (updateResult.isSucceed) {
      emit(ShowInfoAccountSettingsState(
          infoMessage: 'verifyYourNewEmailVerificationLinkIsSend'.tr));
    } else {
      emit(ErrorAccountSettingsState(
          errorMesage: 'systemErrorPleaseContactUs'.tr));
    }
  }

  Future tryChangeUsername(String newUsername) async {
    var user = _userService.currentLoggedInUser;
    var isDataChanged = false;

    if (newUsername == user!.displayName) {
      return isDataChanged;
    } else if (newUsername.isEmpty) {
      emit(ErrorAccountSettingsState(errorMesage: 'emptyUsernameError'.tr));

      return isDataChanged;
    }

    var updateResult = await _userService.updateUserUsername(newUsername);
    if (updateResult.isSucceed) {
      isDataChanged = true;

      var result = await _commentsService.updateCommentsOwnerName(
          newUsername, user!.uid);
      if (result.isFailed) {
        emit(ErrorAccountSettingsState(
            errorMesage: 'systemErrorPleaseContactUs'.tr));
      }
    } else {
      emit(ErrorAccountSettingsState(
          errorMesage: 'systemErrorPleaseContactUs'.tr));
    }

    return isDataChanged;
  }

  Future<bool> tryChangePassword(
      String newPassword, String confirmNewPassword, String oldPassword) async {
    var isDataChanged = false;

    if (newPassword.isEmpty && confirmNewPassword.isEmpty) {
      return isDataChanged;
    } else if (!RegExp(Constants.passwordRegex).hasMatch(newPassword)) {
      emit(ErrorAccountSettingsState(errorMesage: 'weekPasswordError'.tr));

      return isDataChanged;
    } else if (newPassword != confirmNewPassword) {
      emit(ErrorAccountSettingsState(errorMesage: 'notMatchPasswordError'.tr));

      return isDataChanged;
    }

    var isOldPasswordMatchResult =
        await _userService.validateCurrentPassword(oldPassword);

    if (isOldPasswordMatchResult.isFailed) {
      emit(ErrorAccountSettingsState(errorMesage: 'incorrectOldPassword'.tr));

      return isDataChanged;
    }

    var updateResult = await _userService.updateUserPassword(newPassword);
    if (updateResult.isSucceed) {
      isDataChanged = true;
    } else {
      emit(ErrorAccountSettingsState(
          errorMesage: 'systemErrorPleaseContactUs'.tr));
    }

    return isDataChanged;
  }
}
