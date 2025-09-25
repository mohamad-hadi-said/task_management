import 'package:freezed_annotation/freezed_annotation.dart';

part 'subtask_model.g.dart';

@JsonSerializable()
class SubtaskModel {
  final int id;
  @JsonKey(name: 'task_id')
  final int taskId;
  late final String title;
  @JsonKey(name: 'is_done', defaultValue: false)
  final bool isDone;

  SubtaskModel({
    required this.id,
    required this.taskId,
    required this.title,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() => _$SubtaskModelToJson(this);

  factory SubtaskModel.fromJson(Map<String, dynamic> json) =>
      _$SubtaskModelFromJson(json);

  // For database operations
  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'task_id': taskId,
      'title': title,
      'is_done': isDone ? 1 : 0,
    };
  }

  factory SubtaskModel.fromMap(Map<String, dynamic> map) {
    return SubtaskModel(
      id: map['id'],
      taskId: map['task_id'],
      title: map['title'],
      isDone: map['is_done'] == 1,
    );
  }
}
