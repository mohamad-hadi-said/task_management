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
  final TaskStatus status;
  final Priority priority;

  bool get isDone => status == TaskStatus.done;

  TaskModel({
    required this.id,
    required this.title,
    required this.note,
    required this.dueTime,
    TaskStatus status = TaskStatus.todo,
    bool? isDone,
    this.priority = Priority.medium,
  }) : status = status != TaskStatus.todo
            ? status
            : (isDone == true ? TaskStatus.done : status);

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
      'status': status.index,
      'is_done': isDone ? 1 : 0,
      'priority': priority.index,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    TaskStatus taskStatus;
    if (map['status'] != null) {
      final statusIdx = map['status'] as int;
      if (statusIdx >= 0 && statusIdx < TaskStatus.values.length) {
        taskStatus = TaskStatus.values[statusIdx];
      } else {
        taskStatus = TaskStatus.todo;
      }
    } else if (map['is_done'] != null) {
      taskStatus = map['is_done'] == 1 ? TaskStatus.done : TaskStatus.todo;
    } else {
      taskStatus = TaskStatus.todo;
    }

    return TaskModel(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      dueTime: DateTime.parse(map['due_time']),
      status: taskStatus,
      priority: Priority.values[map['priority']],
    );
  }

  TaskModel copyWith({
    int? id,
    String? title,
    String? note,
    DateTime? dueTime,
    TaskStatus? status,
    Priority? priority,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      dueTime: dueTime ?? this.dueTime,
      status: status ?? this.status,
      priority: priority ?? this.priority,
    );
  }
}

