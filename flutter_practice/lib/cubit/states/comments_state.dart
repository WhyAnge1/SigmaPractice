import '../../repository/models/comment_model.dart';

abstract class CommentsState {
  final bool shouldBuild;

  CommentsState({this.shouldBuild = true});
}

class ErrorCommentsState extends CommentsState {
  final String errorMesage;

  ErrorCommentsState({required this.errorMesage}) : super(shouldBuild: false);
}

class LoadedCommentsState extends CommentsState {
  final List<CommentModel> comments;

  LoadedCommentsState({required this.comments});
}

class InitialCommentsState extends CommentsState {}

class NoDataCommentsState extends CommentsState {}
