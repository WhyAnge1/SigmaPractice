import 'package:injectable/injectable.dart';

import '../helpers/result.dart';
import '../misc/constants.dart';
import '../repository/models/comment_model.dart';
import '../repository/repositories/database.dart';

@injectable
class CommentsService {
  Future<Result<List<CommentModel>>> getSavedComments() async {
    MobileDatabase? database;
    Result<List<CommentModel>> result;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      var comments = await database.commentDao.getAllComments();

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
      String newOwnerName, int ownerId) async {
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
