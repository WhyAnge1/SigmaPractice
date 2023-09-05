import 'dart:core';

class LoginState {
  String? errorText;
  bool isLoading;

  LoginState(
      {this.errorText,
      this.isLoading = false});
}
