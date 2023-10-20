import 'package:floor/floor.dart';

import '../models/comment_model.dart';

@dao
abstract class CommentDao {
  @Query('SELECT * FROM CommentModel')
  Future<List<CommentModel>> getAllComments();

  @insert
  Future<void> insertComment(CommentModel model);

  @delete
  Future<void> deleteComment(CommentModel model);

  @Query(
      'Update CommentModel Set ownerName = :newOwnerName Where ownerId = :ownerId')
  Future<void> updateCommentsOwnerName(String newOwnerName, String ownerId);
}
