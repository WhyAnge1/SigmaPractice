import 'package:flutter_practice/helpers/result.dart';
import 'package:flutter_practice/misc/constants.dart';
import 'package:flutter_practice/repository/models/user_model.dart';
import 'package:flutter_practice/repository/repositories/database.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserService {
  Future<Result> saveUser(
      String email, String username, String password) async {
    MobileDatabase? database;
    Result result;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      final newUser =
          UserModel(username: username, email: email, password: password);
      await database.userDao.insertUser(newUser);

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    } finally {
      database?.close();
    }

    return result;
  }

  Future<Result> deleteUser(UserModel userToDelete) async {
    MobileDatabase? database;
    Result result;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      await database.userDao.deleteUser(userToDelete);

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    } finally {
      database?.close();
    }

    return result;
  }

  Future<Result<UserModel?>> getUserByEmail(String email) async {
    MobileDatabase? database;
    Result<UserModel?> result;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      final foundUser = await database.userDao.findUserByEmail(email);

      result = Result.fromResult(foundUser);
    } catch (ex) {
      result = Result.fromError(ex);
    } finally {
      database?.close();
    }

    return result;
  }

  Future<Result> updateUser(UserModel userToUpdate) async {
    MobileDatabase? database;
    Result result;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      await database.userDao.updateUser(userToUpdate);

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    } finally {
      database?.close();
    }

    return result;
  }
}
