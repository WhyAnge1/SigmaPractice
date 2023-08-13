class CreateAccountState {
  bool isAccountCreatedSuccessfully;
  String? errorText;
  String? newUserLogin;
  bool shouldHidePassword;

  CreateAccountState(
      {this.isAccountCreatedSuccessfully = false,
      this.newUserLogin,
      this.errorText,
      this.shouldHidePassword = true});
}
