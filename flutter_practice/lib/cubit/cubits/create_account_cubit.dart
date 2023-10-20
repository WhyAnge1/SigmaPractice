import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/misc/constants.dart';
import 'package:flutter_practice/misc/injection_configurator.dart';
import 'package:flutter_practice/services/authorization_service.dart';
import 'package:get/get.dart';
import '../states/create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  final _authorizationService = getIt<AuthorizationService>();

  CreateAccountCubit() : super(InitialCreateAccountState());

  Future createAccount(String username, String email, String password,
      String confirmPassword) async {
    var validationResult =
        _validateInputData(username, email, password, confirmPassword);

    if (validationResult) {
      var saveResult =
          await _authorizationService.register(username, email, password);

      if (saveResult.isSucceed) {
        emit(SuccessfulCreateAccountState());
      } else if (saveResult.occurredError is FirebaseAuthException) {
        emit(ErrorCreateAccountState(
            errorMesage:
                (saveResult.occurredError as FirebaseAuthException).message!));
      } else {
        emit(ErrorCreateAccountState(
            errorMesage: 'systemErrorPleaseContactUs'.tr));
      }
    }
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
