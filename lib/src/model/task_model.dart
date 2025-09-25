import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_management/core/utils/enums.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  final int id;
  final String title;
  final String note;
  @JsonKey(name: 'due_time')
  final DateTime dueTime;
  @JsonKey(name: 'is_done', defaultValue: false)
  final bool isDone;
  final Priority priority;

  TaskModel({
    required this.id,
    required this.title,
    required this.note,
    required this.dueTime,
    this.isDone = false,
    this.priority = Priority.medium,
  });

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  // For database operations
  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'title': title,
      'note': note,
      'due_time': dueTime.toIso8601String(),
      'is_done': isDone ? 1 : 0,
      'priority': priority.index,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      dueTime: DateTime.parse(map['due_time']),
      isDone: map['is_done'] == 1,
      priority: Priority.values[map['priority']],
    );
  }
}
