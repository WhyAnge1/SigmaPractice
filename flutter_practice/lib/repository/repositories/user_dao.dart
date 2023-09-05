import 'package:floor/floor.dart';

import '../models/user_model.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM UserModel WHERE email = :email')
  Future<UserModel?> findUserByEmail(String email);

  @Query('SELECT * FROM UserModel WHERE id = :id')
  Future<UserModel?> findUserById(int id);

  @insert
  Future<void> insertUser(UserModel person);

  @delete
  Future<void> deleteUser(UserModel person);

  @update
  Future<void> updateUser(UserModel person);
}
