import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  final int id;
  final String title;
  final String? body;
  final String? description;
  final String status;

  Task({
    required this.id,
    required this.title,
    required this.body,
    required this.description,
    required this.status,
  });
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Task copyWith({
    int? id,
    String? title,
    String? body,
    String? description,
    String? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}
