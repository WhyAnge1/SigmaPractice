import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/services/comments_service.dart';
import 'package:flutter_practice/repository/models/comment_model.dart';
import 'package:get/get.dart';
import '../../misc/user_info.dart';
import '../states/comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final _commentsService = CommentsService();

  CommentsCubit() : super(InitialCommentsState());

  Future loadComments() async {
    var newCommentsResult = await _commentsService.getSavedComments();

    if (newCommentsResult.isSucceed) {
      if (newCommentsResult.result!.isNotEmpty) {
        emit(LoadedCommentsState(comments: newCommentsResult.result!));
      } else {
        emit(NoDataCommentsState());
      }
    } else {
      emit(ErrorCommentsState(errorMesage: 'systemErrorPleaseContactUs'.tr));
    }
  }

  Future deleteComment(CommentModel commentToDelete) async {
    var newCommentsResult =
        await _commentsService.deleteComment(commentToDelete);

    if (newCommentsResult.isSucceed) {
      if (newCommentsResult.result!.isNotEmpty) {
        emit(LoadedCommentsState(comments: newCommentsResult.result!));
      } else {
        emit(NoDataCommentsState());
      }
    } else {
      emit(ErrorCommentsState(errorMesage: 'systemErrorPleaseContactUs'.tr));
    }
  }

  Future saveComment(String comment, double rating) async {
    if (rating < 0.0 && rating > 5.0) {
      throw ArgumentError("Rating value can be from 0.0 to 5.0");
    }

    if (comment.isEmpty) {
      emit(ErrorCommentsState(errorMesage: 'commentFieldCanNotBeEmpty'.tr));
    } else {
      final newComment = CommentModel(
          ownerId: UserInfo.loggedInUser!.id!,
          comment: comment,
          rating: rating,
          ownerName: UserInfo.loggedInUser!.username);

      var newCommentsResult = await _commentsService.saveComment(newComment);

      if (newCommentsResult.isSucceed) {
        emit(LoadedCommentsState(comments: newCommentsResult.result!));
      } else {
        emit(ErrorCommentsState(errorMesage: 'systemErrorPleaseContactUs'.tr));
      }
    }
  }
}
