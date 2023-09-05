import 'package:floor/floor.dart';

import '../models/comment_model.dart';

@dao
abstract class CommentDao {
  @Query('SELECT * FROM CommentModel')
  Future<List<CommentModel>> getAllComments();

  @insert
  Future<void> insertComment(CommentModel person);

  @delete
  Future<void> deleteComment(CommentModel person);

  @Query('Update CommentModel Set ownerName = :newOwnerName Where ownerId = :ownerId')
   Future<void> updateCommentsOwnerName(String newOwnerName, int ownerId);
}