import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  final int id;
  final String title;
  final String description;
  final String owner;
  final String readMe;
  final List<String> collaborators;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.owner,
    required this.collaborators,
    required this.readMe,
  });
  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
