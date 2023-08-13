import 'dart:core';

class LoginState {
  String? errorText;
  bool isloginSuccessful;
  bool shouldRememberLogin ;
  bool shouldHidePassword ;

  LoginState(
      {this.errorText,
      this.isloginSuccessful = false,
      this.shouldRememberLogin = false,
      this.shouldHidePassword = true});
}
