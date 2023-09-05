import '../repository/models/user_model.dart';

class UserInfo {
  static UserModel? _loggedInUser;
  static UserModel? get loggedInUser => _loggedInUser;
  static bool get isLoggedIn => loggedInUser != null;

  static void saveLoggenInUser(UserModel newUser) => _loggedInUser = newUser;

  static void clearLoggedInUser() => _loggedInUser = null;
}
