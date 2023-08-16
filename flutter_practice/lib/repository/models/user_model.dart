import 'package:floor/floor.dart';

@entity
class UserModel {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final String email;
  final String password;
  final String username;

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
