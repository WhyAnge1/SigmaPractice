import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/misc/user_info.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../misc/constants.dart';
import '../../repository/repositories/database.dart';
import '../states/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  Future<bool> tryLoginBySavedEmail() async {
    MobileDatabase? database;
    bool isLoggedIn = false;

    _emit(isLoading: true);

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
          _emit(errorText: 'userEmailExistError'.tr);
        } else {
          UserInfo.saveLoggenInUser(foundUser);
          isLoggedIn = true;
        }
      } catch (ex) {
        _emit(errorText: 'systemErrorPleaseContactUs'.tr);
      } finally {
        database?.close();
      }
    }
    
    _emit();

    return isLoggedIn;
  }

  Future<bool> login(String email, String password, bool shouldLogin) async {
    MobileDatabase? database;
    bool isLoggedIn = false;

    _emit(isLoading: true);

    if (validateInputData(email, password)) {
      try {
        database = await $FloorMobileDatabase
            .databaseBuilder(Constants.databaseFileName)
            .build();

        final foundUser = await database.userDao.findUserByEmail(email);

        if (foundUser == null || foundUser.password != password) {
          _emit(errorText: 'userNotExistOrPasswordWrongError'.tr);
        } else {
          UserInfo.saveLoggenInUser(foundUser);

          final prefferences = await SharedPreferences.getInstance();

          prefferences.setString(
              Constants.autoLoginEmailPreffName, foundUser.email);

          isLoggedIn = true;
        }
      } catch (ex) {
        _emit(errorText: 'systemErrorPleaseContactUs'.tr);
      } finally {
        database?.close();
      }
    }

    _emit();

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
      _emit(errorText: errorText);
    }

    return isValid;
  }

  void _emit({String? errorText, bool isLoading = false}) =>
      emit(LoginState(errorText: errorText, isLoading: isLoading));
}
