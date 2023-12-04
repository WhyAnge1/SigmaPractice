import 'package:floor/floor.dart';

@entity
class CommentModel {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String ownerId;
  double rating;
  String comment;
  String ownerName;
  String? ownerPhotoUrl;

  @ignore
  bool isBelongToCurrentUser;

  CommentModel(
      {this.id,
      required this.ownerId,
      required this.rating,
      required this.comment,
      required this.ownerName,
      this.ownerPhotoUrl,
      this.isBelongToCurrentUser = false});

  @override
  bool operator ==(Object other) => other is CommentModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
