import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_practice/helpers/result.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserService {
  User? get currentLoggedInUser => FirebaseAuth.instance.currentUser;

  Future<Result> reloadUser() async {
    Result result;

    try {
      await FirebaseAuth.instance.currentUser?.reload();

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    }

    return result;
  }

  Future<Result> deleteCurrentUser(String password) async {
    Result result;

    try {
      await _reauthenticateUser(
          FirebaseAuth.instance.currentUser!.email!, password);

      await FirebaseAuth.instance.currentUser?.delete();

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    }

    return result;
  }

  Future<Result> updateUserEmail(String email, String password) async {
    Result result;

    try {
      await _reauthenticateUser(
          FirebaseAuth.instance.currentUser!.email!, password);

      await FirebaseAuth.instance.currentUser?.verifyBeforeUpdateEmail(email);

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    }

    return result;
  }

  Future<Result> updateUserUsername(String username) async {
    Result result;

    try {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(username);

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    }

    return result;
  }

  Future<Result> updateUserPassword(String password) async {
    Result result;

    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(password);

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    }

    return result;
  }

  Future<Result> validateCurrentPassword(String password) async {
    Result result;

    try {
      await _reauthenticateUser(
          FirebaseAuth.instance.currentUser!.email!, password);

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    }

    return result;
  }

  Future _reauthenticateUser(String email, String password) async {
    var credentail =
        EmailAuthProvider.credential(email: email, password: password);

    await FirebaseAuth.instance.currentUser
        ?.reauthenticateWithCredential(credentail);
  }
}
