abstract class HomeState {}

class InitialHomeState extends HomeState {}

class ErrorHomeState extends HomeState {
  final String errorMesage;

  ErrorHomeState({required this.errorMesage});
}

class UserDataHomeState extends HomeState {
  final String username;
  final String email;
  final String? imageUrl;

  UserDataHomeState(
      {required this.username, required this.email, required this.imageUrl});
}

class OpenDrawerState extends HomeState {}
