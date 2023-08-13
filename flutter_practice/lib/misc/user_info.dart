import '../repository/models/user_model.dart';

class UserInfo {
  static UserModel? loggedInUser;
  static bool get isLoggenIn => loggedInUser != null;

  static void saveLoggenInUser(UserModel newUser) => loggedInUser = newUser;

  static void clearLoggenInUser() => loggedInUser = null;
}
