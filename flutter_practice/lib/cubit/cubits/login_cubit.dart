import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/misc/user_info.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../misc/constants.dart';
import '../../repository/repositories/database.dart';
import '../states/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(InitialLoginState());

  Future<bool> tryLoginBySavedEmail() async {
    MobileDatabase? database;
    bool isLoggedIn = false;

    emit(LoadingLoginState());

    final prefferences = await SharedPreferences.getInstance();
    final savedEmail =
        prefferences.getString(Constants.autoLoginEmailPreffName);

    if (savedEmail != null) {
      try {
        database = await $FloorMobileDatabase
            .databaseBuilder(Constants.databaseFileName)
            .build();

        final foundUser = await database.userDao.findUserByEmail(savedEmail);

        if (foundUser == null) {
          emit(ErrorLoginState(errorMesage: 'userEmailExistError'.tr));
        } else {
          UserInfo.saveLoggenInUser(foundUser);
          isLoggedIn = true;

          emit(LoggedInLoginState());
        }
      } catch (ex) {
        emit(ErrorLoginState(errorMesage: 'systemErrorPleaseContactUs'.tr));
      } finally {
        database?.close();
      }
    }

    return isLoggedIn;
  }

  Future<bool> login(String email, String password, bool shouldLogin) async {
    MobileDatabase? database;
    bool isLoggedIn = false;

    emit(LoadingLoginState());

    if (validateInputData(email, password)) {
      try {
        database = await $FloorMobileDatabase
            .databaseBuilder(Constants.databaseFileName)
            .build();

        final foundUser = await database.userDao.findUserByEmail(email);

        if (foundUser == null || foundUser.password != password) {
          emit(ErrorLoginState(
              errorMesage: 'userNotExistOrPasswordWrongError'.tr));
        } else {
          UserInfo.saveLoggenInUser(foundUser);

          final prefferences = await SharedPreferences.getInstance();

          prefferences.setString(
              Constants.autoLoginEmailPreffName, foundUser.email);

          isLoggedIn = true;

          emit(LoggedInLoginState());
        }
      } catch (ex) {
        emit(ErrorLoginState(errorMesage: 'systemErrorPleaseContactUs'.tr));
      } finally {
        database?.close();
      }
    }

    return isLoggedIn;
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
      emit(ErrorLoginState(errorMesage: errorText));
    }

    return isValid;
  }
}
