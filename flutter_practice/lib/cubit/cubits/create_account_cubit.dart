import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/misc/injection_configurator.dart';
import 'package:flutter_practice/services/user_service.dart';
import 'package:get/get.dart';

import '../../misc/constants.dart';
import '../states/create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  final _userService = getIt<UserService>();

  CreateAccountCubit() : super(InitialCreateAccountState());

  Future<bool> createAccount(String username, String email, String password,
      String confirmPassword) async {
    bool isAccountCreated = false;

    if (_validateInputData(username, email, password, confirmPassword)) {
      var existResult = await _userService.getUserByEmail(email);

      if (existResult.isSuccessHasNoResult) {
        var saveResult = await _userService.saveUser(email, username, password);

        if (saveResult.isSucceed) {
          isAccountCreated = true;
        } else {
          emit(ErrorCreateAccountState(
              errorMesage: 'systemErrorPleaseContactUs'.tr));
        }
      } else if (existResult.hasResult) {
        emit(ErrorCreateAccountState(errorMesage: 'emailExistError'.tr));
      } else {
        emit(ErrorCreateAccountState(
            errorMesage: 'systemErrorPleaseContactUs'.tr));
      }
    }

    return isAccountCreated;
  }

  bool _validateInputData(
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
      emit(ErrorCreateAccountState(errorMesage: errorText));
    }

    return isValid;
  }
}
