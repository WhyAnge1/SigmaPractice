import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/repository/models/comment_model.dart';
import 'package:get/get.dart';
import '../../misc/constants.dart';
import '../../misc/user_info.dart';
import '../../repository/repositories/database.dart';
import '../../misc/comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  List<CommentModel> _comments = List<CommentModel>.empty(growable: true);

  CommentsCubit() : super(CommentsState());

  Future loadComments() async {
    MobileDatabase? database;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      _comments = await database.commentDao.getAllComments();

      _emit();
    } catch (ex) {
      _emit(errorText: 'systemErrorPleaseContactUs'.tr);
    } finally {
      database?.close();
    }
  }

  Future deleteComment(CommentModel commentToDelete) async {
    MobileDatabase? database;

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      await database.commentDao.deleteComment(commentToDelete);
      _comments.remove(commentToDelete);

      _emit();
    } catch (ex) {
      _emit(errorText: 'systemErrorPleaseContactUs'.tr);
    } finally {
      database?.close();
    }
  }

  Future saveComment(String comment, double rating) async {
    MobileDatabase? database;

    if (rating < 0.0 && rating > 5.0) {
      throw ArgumentError("Rating value can be from 0.0 to 5.0");
    }

    if (comment.isEmpty) {
      _emit(errorText: "Comment filed can't be empty");

      return;
    }

    try {
      database = await $FloorMobileDatabase
          .databaseBuilder(Constants.databaseFileName)
          .build();

      final newComment = CommentModel(
          ownerId: UserInfo.loggedInUser!.id!,
          comment: comment,
          rating: rating,
          ownerName: UserInfo.loggedInUser!.username);
      await database.commentDao.insertComment(newComment);
      _comments.add(newComment);

      _emit();
    } catch (ex) {
      _emit(errorText: 'systemErrorPleaseContactUs'.tr);
    } finally {
      database?.close();
    }
  }

  void _emit({String? errorText}) =>
      emit(CommentsState(comments: _comments, errorText: errorText));
}
