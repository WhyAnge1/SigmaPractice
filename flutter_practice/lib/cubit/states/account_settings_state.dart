abstract class AccountSettingsState {}

class InitialAccountSettingsState extends AccountSettingsState {}

class ErrorAccountSettingsState extends AccountSettingsState {
  final String errorMesage;

  ErrorAccountSettingsState({required this.errorMesage});
}

class ShowInfoAccountSettingsState extends AccountSettingsState {
  final String infoMessage;

  ShowInfoAccountSettingsState({required this.infoMessage});
}

class UserDataAccountSettingsState extends AccountSettingsState {
  final String username;
  final String email;
  final String? imageUrl;

  UserDataAccountSettingsState(
      {required this.username, required this.email, required this.imageUrl});
}

class LoadingAvatarAccountSettingsState extends AccountSettingsState {
  final bool isLoading;

  LoadingAvatarAccountSettingsState({this.isLoading = true});
}
