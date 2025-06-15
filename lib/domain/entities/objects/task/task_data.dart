import 'package:jigsaw_client/domain/entities/objects/task/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_data.g.dart';

@JsonSerializable()
class TaskData {
  final int total;
  List<Task> tasks;

  TaskData({required this.total, required this.tasks});
  factory TaskData.fromJson(Map<String, dynamic> json) =>
      _$TaskDataFromJson(json);
  Map<String, dynamic> toJson() => _$TaskDataToJson(this);
}
