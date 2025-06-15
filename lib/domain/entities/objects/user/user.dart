import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String nickname;
  final String role;
  final String fName;
  final String lName;

  User({
    required this.id,
    required this.nickname,
    required this.role,
    required this.fName,
    required this.lName,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
