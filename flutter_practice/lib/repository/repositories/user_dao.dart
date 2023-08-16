import 'package:floor/floor.dart';

import '../models/user_model.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM UserModel WHERE email = :email')
  Future<UserModel?> findUserByEmail(String email);

  @insert
  Future<void> insertUser(UserModel person);
}
