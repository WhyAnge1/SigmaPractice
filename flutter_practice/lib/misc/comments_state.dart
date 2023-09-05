import '../repository/models/comment_model.dart';

class CommentsState {
  List<CommentModel>? comments;
  String? errorText;

  CommentsState({this.comments, this.errorText});
}
