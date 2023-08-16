import '../repository/models/user_model.dart';

class UserInfo {
  static UserModel? loggedInUser;
  static bool get isLoggedIn => loggedInUser != null;

  static void saveLoggenInUser(UserModel newUser) => loggedInUser = newUser;

  static void clearLoggedInUser() => loggedInUser = null;
}
