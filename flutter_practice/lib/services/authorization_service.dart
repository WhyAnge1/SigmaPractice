import 'package:flutter_practice/exception/email_not_verified_exception.dart';
import 'package:flutter_practice/helpers/result.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart';

@injectable
class AuthorizationService {
  Future<Result> login(String email, String password) async {
    Result result;

    try {
      var credentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (credentials.user != null && !credentials.user!.emailVerified) {
        _sendVerificationToEmail();
        logout();

        result = Result.fromError(EmailNotVerifiedException());
      } else {
        result = Result.fromSuccess();
      }
    } catch (ex) {
      result = Result.fromError(ex);
    }

    return result;
  }

  Future<Result> register(
      String username, String email, String password) async {
    Result<User> result;

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.currentUser?.updateDisplayName(username);
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      await FirebaseAuth.instance.signOut();

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    }

    return result;
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<Result> _sendVerificationToEmail() async {
    Result result;

    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    }

    return result;
  }
}
