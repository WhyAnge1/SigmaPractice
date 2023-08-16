import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:flutter_practice/repository/repositories/user_dao.dart';

import '../models/user_model.dart';

part 'database.g.dart';

@Database(version: 1, entities: [UserModel])
abstract class MobileDatabase extends FloorDatabase {
  UserDao get userDao;
}
