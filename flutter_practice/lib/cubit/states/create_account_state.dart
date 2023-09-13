abstract class CreateAccountState {}

class ErrorCreateAccountState extends CreateAccountState {
  final String errorMesage;

  ErrorCreateAccountState({required this.errorMesage});
}

class SuccessfulCreateAccountState extends CreateAccountState {}

class InitialCreateAccountState extends CreateAccountState {}
