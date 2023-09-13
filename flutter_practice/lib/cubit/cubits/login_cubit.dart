import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/misc/injection_configurator.dart';
import 'package:flutter_practice/services/authorization_service.dart';
import 'package:flutter_practice/services/user_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../misc/constants.dart';
import '../states/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final _authorizationService = getIt<AuthorizationService>();
  final _userService = getIt<UserService>();

  LoginCubit() : super(InitialLoginState());

  Future<bool> tryLoginBySavedEmail() async {
    bool isLoggedIn = false;

    final prefferences = await SharedPreferences.getInstance();
    final savedEmail =
        prefferences.getString(Constants.autoLoginEmailPreffName);

    if (savedEmail != null) {
      final foundUserResult = await _userService.getUserByEmail(savedEmail);

      if (foundUserResult.hasResult) {
        var loginResult =
            await _authorizationService.login(foundUserResult.result!);

        if (loginResult.isSucceed) {
          isLoggedIn = true;

          emit(SuccessfulLoginState());
        } else {
          emit(ErrorLoginState(errorMesage: 'systemErrorPleaseContactUs'.tr));
        }
      }
    }

    return isLoggedIn;
  }

  Future<bool> login(String email, String password, bool shouldLogin) async {
    bool isLoggedIn = false;

    emit(LoadingLoginState());

    if (_validateInputData(email, password)) {
      final foundUserResult = await _userService.getUserByEmail(email);

      if (foundUserResult.isSuccessHasNoResult ||
          foundUserResult.hasResult &&
              foundUserResult.result!.password != password) {
        emit(ErrorLoginState(
            errorMesage: 'userNotExistOrPasswordWrongError'.tr));
      } else if (foundUserResult.hasResult) {
        var loginResult =
            await _authorizationService.login(foundUserResult.result!);

        if (loginResult.isSucceed) {
          isLoggedIn = true;

          emit(SuccessfulLoginState());
        } else {
          emit(ErrorLoginState(errorMesage: 'systemErrorPleaseContactUs'.tr));
        }
      } else {
        emit(ErrorLoginState(errorMesage: 'systemErrorPleaseContactUs'.tr));
      }
    }

    return isLoggedIn;
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
