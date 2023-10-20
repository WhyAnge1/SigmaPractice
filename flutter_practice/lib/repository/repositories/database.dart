import 'dart:async';
import 'package:floor/floor.dart';
import 'package:flutter_practice/repository/repositories/comment_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/comment_model.dart';

part 'database.g.dart';

@Database(version: 1, entities: [CommentModel])
abstract class MobileDatabase extends FloorDatabase {
  CommentDao get commentDao;
}
