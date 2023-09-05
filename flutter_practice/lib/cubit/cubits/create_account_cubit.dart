import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../misc/constants.dart';
import '../../repository/models/user_model.dart';
import '../../repository/repositories/database.dart';
import '../states/create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountCubit() : super(CreateAccountState());

  Future<bool> createAccount(String username, String email, String password,
      String confirmPassword) async {
    MobileDatabase? database;
    bool isAccountCreated = false;

    if (validateInputData(username, email, password, confirmPassword)) {
      try {
        database = await $FloorMobileDatabase
            .databaseBuilder(Constants.databaseFileName)
            .build();

        final existUser = await database.userDao.findUserByEmail(email);

        if (existUser != null) {
          _emit(errorText: 'emailExistError'.tr);
        } else {
          final newUser =
              UserModel(username: username, email: email, password: password);
          await database.userDao.insertUser(newUser);

          isAccountCreated = true;
        }
      } catch (ex) {
        _emit(errorText: 'systemErrorPleaseContactUs'.tr);
      } finally {
        database?.close();
      }
    }

    return isAccountCreated;
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
      _emit(errorText: errorText);
    }

    return isValid;
  }

  void _emit({String? errorText}) =>
      emit(CreateAccountState(errorText: errorText));
}
