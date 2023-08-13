import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/misc/user_info.dart';
import 'package:get/get.dart';

import '../../misc/constants.dart';
import '../../repository/repositories/database.dart';
import '../states/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  bool _shouldRememberLogin = false;
  bool _shouldHidePassword = true;

  LoginCubit() : super(LoginState());

  Future<bool> loginByEmail(String email) async {
    MobileDatabase? database;
    bool isLoggedIn = false;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      final foundUser = await database.userDao.findUserByEmail(email);

      if (foundUser == null) {
        emit(LoginState(
            errorText: 'userEmailExistError'.tr,
            shouldRememberLogin: _shouldRememberLogin,
            shouldHidePassword: _shouldHidePassword));
      } else {
        UserInfo.saveLoggenInUser(foundUser);
        isLoggedIn = true;
      }
    } catch (ex) {
      emit(LoginState(
          errorText: 'systemErrorPleaseContactUs'.tr,
          shouldRememberLogin: _shouldRememberLogin,
          shouldHidePassword: _shouldHidePassword));
    } finally {
      database?.close();
    }

    return isLoggedIn;
  }

  void setShouldRememberLogin(bool newValue) {
    _shouldRememberLogin = newValue;

    emit(LoginState(
        shouldRememberLogin: _shouldRememberLogin,
        shouldHidePassword: _shouldHidePassword));
  }

  void setShouldHidePassword(bool newValue) {
    _shouldHidePassword = newValue;

    emit(LoginState(
        shouldRememberLogin: _shouldRememberLogin,
        shouldHidePassword: _shouldHidePassword));
  }

  Future login(String email, String password) async {
    MobileDatabase? database;

    if (!validateInputData(email, password)) {
      return;
    }

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      final foundUser = await database.userDao.findUserByEmail(email);

      if (foundUser == null || foundUser.password != password) {
        emit(LoginState(
            errorText: 'userNotExistOrPasswordWrongError'.tr,
            shouldRememberLogin: _shouldRememberLogin,
            shouldHidePassword: _shouldHidePassword));
      } else {
        UserInfo.saveLoggenInUser(foundUser);

        emit(LoginState(
            isloginSuccessful: true,
            shouldRememberLogin: _shouldRememberLogin,
            shouldHidePassword: _shouldHidePassword));
      }
    } catch (ex) {
      emit(LoginState(
          errorText: 'systemErrorPleaseContactUs'.tr,
          shouldRememberLogin: _shouldRememberLogin,
          shouldHidePassword: _shouldHidePassword));
    } finally {
      database?.close();
    }
  }

  bool validateInputData(String email, String password) {
    var isValid = true;
    String? errorText;

    if (email.isEmpty) {
      errorText = 'emptyEmailError'.tr;
    } else if (password.isEmpty) {
      errorText = 'emptyPasswordError'.tr;
    }

    isValid = errorText == null;
    if (!isValid) {
      emit(LoginState(
          errorText: errorText,
          shouldRememberLogin: _shouldRememberLogin,
          shouldHidePassword: _shouldHidePassword));
    }

    return isValid;
  }
}
