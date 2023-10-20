import 'package:flutter_practice/services/user_service.dart';
import 'package:injectable/injectable.dart';

import '../helpers/result.dart';
import '../misc/constants.dart';
import '../repository/models/comment_model.dart';
import '../repository/repositories/database.dart';

@injectable
class CommentsService {
  final UserService _userService;

  CommentsService(UserService userService) : _userService = userService;

  Future<Result<List<CommentModel>>> getSavedComments() async {
    MobileDatabase? database;
    Result<List<CommentModel>> result;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      var comments = await database.commentDao.getAllComments();

      for (var comment in comments) {
        comment.isBelongToCurrentUser =
            comment.ownerId == _userService.currentLoggedInUser?.uid;
      }

      result = Result.fromResult(comments);
    } catch (ex) {
      result = Result.fromError(ex);
    } finally {
      database?.close();
    }

    return result;
  }

  Future<Result> saveComment(CommentModel commentToSave) async {
    MobileDatabase? database;
    Result<List<CommentModel>> result;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      await database.commentDao.insertComment(commentToSave);

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    } finally {
      database?.close();
    }

    return result;
  }

  Future<Result> deleteComment(CommentModel commentToDelete) async {
    MobileDatabase? database;
    Result<List<CommentModel>> result;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      await database.commentDao.deleteComment(commentToDelete);

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    } finally {
      database?.close();
    }

    return result;
  }

  Future<Result> updateCommentsOwnerName(
      String newOwnerName, String ownerId) async {
    MobileDatabase? database;
    Result<List<CommentModel>> result;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      await database.commentDao.updateCommentsOwnerName(newOwnerName, ownerId);

      result = Result.fromSuccess();
    } catch (ex) {
      result = Result.fromError(ex);
    } finally {
      database?.close();
    }

    return result;
  }
}
