import 'package:flutter_practice/helpers/result.dart';
import 'package:flutter_practice/misc/constants.dart';
import 'package:flutter_practice/misc/user_info.dart';
import 'package:flutter_practice/repository/models/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class AuthorizationService {
  Future<Result> login(UserModel user) async {
    Result result;

    try {
      UserInfo.saveLoggenInUser(user);

      final prefferences = await SharedPreferences.getInstance();
      prefferences.setString(Constants.autoLoginEmailPreffName, user.email);

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    }

    return result;
  }

  Future logout() async {
    final prefferences = await SharedPreferences.getInstance();
    prefferences.remove(Constants.autoLoginEmailPreffName);
    UserInfo.clearLoggedInUser();
  }
}
