import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../misc/constants.dart';
import '../../repository/models/user_model.dart';
import '../../repository/repositories/database.dart';
import '../states/create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  bool _shouldHidePassword = true;

  CreateAccountCubit() : super(CreateAccountState());

  void setShouldHidePassword(bool newValue) {
    _shouldHidePassword = newValue;
    emit(CreateAccountState(shouldHidePassword: _shouldHidePassword));
  }

  Future createAccount(String username, String email, String password,
      String confirmPassword) async {
    MobileDatabase? database;

    if (!validateInputData(username, email, password, confirmPassword)) {
      return;
    }

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      final existUser = await database.userDao.findUserByEmail(email);
      if (existUser != null) {
        emit(CreateAccountState(
            errorText: 'emailExistError'.tr,
            shouldHidePassword: _shouldHidePassword));
      } else {
        final newUser =
            UserModel(username: username, email: email, password: password);
        await database.userDao.insertUser(newUser);

        emit(CreateAccountState(
            isAccountCreatedSuccessfully: true,
            newUserLogin: email,
            shouldHidePassword: _shouldHidePassword));
      }
    } catch (ex) {
      emit(CreateAccountState(
          errorText: 'systemErrorPleaseContactUs'.tr,
          shouldHidePassword: _shouldHidePassword));
    } finally {
      database?.close();
    }
  }

  bool validateInputData(
      String username, String email, String password, String confirmPassword) {
    var isValid = true;
    String? errorText;

    if (username.isEmpty) {
      errorText = 'emptyUsernameError'.tr;
    } else if (!EmailValidator.validate(email)) {
      errorText = 'emailNotValidError'.tr;
    } else if (password.isEmpty) {
      errorText = 'emptyPasswordError'.tr;
    } else if (!RegExp(Constants.passwordRegex).hasMatch(password)) {
      errorText = 'weekPasswordError'.tr;
    } else if (password != confirmPassword) {
      errorText = 'notMatchPasswordError'.tr;
    }

    isValid = errorText == null;
    if (!isValid) {
      emit(CreateAccountState(
          errorText: errorText, shouldHidePassword: _shouldHidePassword));
    }

    return isValid;
  }
}
