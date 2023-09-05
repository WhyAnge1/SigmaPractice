import 'package:floor/floor.dart';

@entity
class UserModel {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String email;
  String password;
  String username;

  UserModel(
      {this.id,
      required this.email,
      required this.password,
      required this.username});

  @override
  bool operator ==(Object other) => other is UserModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
