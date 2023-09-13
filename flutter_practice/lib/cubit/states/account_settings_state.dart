abstract class AccountSettingsState {}

class InitialAccountSettingsState extends AccountSettingsState {}

class ErrorAccountSettingsState extends AccountSettingsState {
  final String errorMesage;

  ErrorAccountSettingsState({required this.errorMesage});
}
