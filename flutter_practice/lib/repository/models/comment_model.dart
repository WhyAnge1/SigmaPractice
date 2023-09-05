import 'package:floor/floor.dart';
import 'package:flutter_practice/misc/user_info.dart';
import 'package:flutter_practice/repository/models/user_model.dart';

@Entity(foreignKeys: [
  ForeignKey(
      childColumns: ['ownerId'], parentColumns: ['id'], entity: UserModel, onDelete: ForeignKeyAction.cascade)
])
class CommentModel {
  @PrimaryKey(autoGenerate: true)
  int? id;
  int ownerId;
  double rating;
  String comment;
  String ownerName;
  String? ownerImageFilePath;

  bool get isBelongToCurrentUser => ownerId == UserInfo.loggedInUser?.id;

  CommentModel(
      {this.id,
      required this.ownerId,
      required this.rating,
      required this.comment,
      required this.ownerName,
      this.ownerImageFilePath});

  @override
  bool operator ==(Object other) => other is CommentModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
