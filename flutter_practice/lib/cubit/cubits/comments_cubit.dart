import 'package:event_bus_plus/res/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/event_bus_events/open_drawer_event.dart';
import 'package:flutter_practice/misc/injection_configurator.dart';
import 'package:flutter_practice/services/comments_service.dart';
import 'package:flutter_practice/repository/models/comment_model.dart';
import 'package:flutter_practice/services/user_service.dart';
import 'package:get/get.dart';
import '../states/comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final _commentsService = getIt<CommentsService>();
  final _userService = getIt<UserService>();
  final _eventBus = getIt<EventBus>();
  List<CommentModel> _cachedComments = List.empty(growable: true);

  CommentsCubit() : super(InitialCommentsState());

  Future loadComments() async {
    var newCommentsResult = await _commentsService.getSavedComments();

    if (newCommentsResult.isSucceed) {
      if (newCommentsResult.hasResult && newCommentsResult.result!.isNotEmpty) {
        _cachedComments = newCommentsResult.result!;

        emit(LoadedCommentsState(comments: _cachedComments));
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
      _cachedComments.remove(commentToDelete);

      if (_cachedComments.isNotEmpty) {
        emit(LoadedCommentsState(comments: _cachedComments));
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
      var currentUser = _userService.currentLoggedInUser!;

      final newComment = CommentModel(
          ownerId: currentUser.uid,
          comment: comment,
          rating: rating,
          ownerName: currentUser.displayName ?? "",
          ownerPhotoUrl: currentUser.photoURL,
          isBelongToCurrentUser: true);

      var saveCommentsResult = await _commentsService.saveComment(newComment);

      if (saveCommentsResult.isSucceed) {
        _cachedComments.add(newComment);

        emit(LoadedCommentsState(comments: _cachedComments));
      } else {
        emit(ErrorCommentsState(errorMesage: 'systemErrorPleaseContactUs'.tr));
      }
    }
  }

  void sendOpenDrawerEvent() {
    _eventBus.fire(OpenDrawerEvent());
  }
}
