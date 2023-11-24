abstract class HomeState {}

class InitialHomeState extends HomeState {}

class ErrorHomeState extends HomeState {
  final String errorMesage;

  ErrorHomeState({required this.errorMesage});
}

class DefaultHomeState extends HomeState {
  final String username;
  final String email;

  DefaultHomeState({required this.username, required this.email});
}
