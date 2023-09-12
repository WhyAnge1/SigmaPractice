import 'dart:core';

abstract class LoginState {}

class ErrorLoginState extends LoginState {
  final String errorMesage;

  ErrorLoginState({required this.errorMesage});
}

class LoadingLoginState extends LoginState {}

class LoggedInLoginState extends LoginState {}

class InitialLoginState extends LoginState {}
