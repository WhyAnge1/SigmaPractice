import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/exception/email_not_verified_exception.dart';
import 'package:flutter_practice/misc/injection_configurator.dart';
import 'package:flutter_practice/services/authorization_service.dart';
import 'package:flutter_practice/services/user_service.dart';
import 'package:get/get.dart';

import '../states/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final _authorizationService = getIt<AuthorizationService>();
  final _userService = getIt<UserService>();

  LoginCubit() : super(InitialLoginState());

  Future<bool> tryAutoLogin() async {
    bool isLoggedIn = false;

    final savedUser = _userService.currentLoggedInUser;

    if (savedUser != null) {
      isLoggedIn = true;
      emit(SuccessfulLoginState());
    }

    return isLoggedIn;
  }

  Future login(String email, String password) async {
    emit(LoadingLoginState());

    if (_validateInputData(email, password)) {
      var loginResult = await _authorizationService.login(email, password);

      if (loginResult.isSucceed) {
        emit(SuccessfulLoginState());
      } else if (loginResult.occurredError is EmailNotVerifiedException) {
        emit(ErrorLoginState(errorMesage: 'emailForThisUserIsNotVerified'.tr));
      } else if (loginResult.occurredError is FirebaseAuthException) {
        var firebaseError = loginResult.occurredError as FirebaseAuthException;

        if (firebaseError.code == 'user-not-found' ||
            firebaseError.code == 'wrong-password') {
          emit(ErrorLoginState(
              errorMesage: 'userNotExistOrPasswordWrongError'.tr));
        } else {
          emit(ErrorLoginState(errorMesage: 'systemErrorPleaseContactUs'.tr));
        }
      } else {
        emit(ErrorLoginState(errorMesage: 'systemErrorPleaseContactUs'.tr));
      }
    }
  }

  bool _validateInputData(String email, String password) {
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
