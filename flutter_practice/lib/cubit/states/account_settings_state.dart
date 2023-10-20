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

class DefaultUserDataAccountSettingsState extends AccountSettingsState {
  final String username;
  final String email;

  DefaultUserDataAccountSettingsState(
      {required this.username, required this.email});
}
