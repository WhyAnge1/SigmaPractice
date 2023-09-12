import '../helpers/result.dart';
import '../misc/constants.dart';
import '../repository/models/comment_model.dart';
import '../repository/repositories/database.dart';

class CommentsService {
  List<CommentModel> _comments = List<CommentModel>.empty(growable: true);

  Future<Result<List<CommentModel>>> getSavedComments() async {
    MobileDatabase? database;
    Result<List<CommentModel>> result;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      _comments = await database.commentDao.getAllComments();

      result = Result(result: _comments);
    } catch (ex) {
      result = Result(occurredError: ex);
    } finally {
      database?.close();
    }

    return result;
  }

  Future<Result<List<CommentModel>>> saveComment(
      CommentModel commentToSave) async {
    MobileDatabase? database;
    Result<List<CommentModel>> result;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      await database.commentDao.insertComment(commentToSave);
      _comments.add(commentToSave);

      result = Result(result: _comments);
    } catch (ex) {
      result = Result(occurredError: ex);
    } finally {
      database?.close();
    }

    return result;
  }

  Future<Result<List<CommentModel>>> deleteComment(
      CommentModel commentToDelete) async {
    MobileDatabase? database;
    Result<List<CommentModel>> result;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      await database.commentDao.deleteComment(commentToDelete);
      _comments.remove(commentToDelete);

      result = Result(result: _comments);
    } catch (ex) {
      result = Result(occurredError: ex);
    } finally {
      database?.close();
    }

    return result;
  }
}
