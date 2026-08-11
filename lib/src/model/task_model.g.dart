// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  note: json['note'] as String,
  dueTime: DateTime.parse(json['due_time'] as String),
  status:
      $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
      TaskStatus.todo,
  priority:
      $enumDecodeNullable(_$PriorityEnumMap, json['priority']) ??
      Priority.medium,
);

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'note': instance.note,
  'due_time': instance.dueTime.toIso8601String(),
  'status': _$TaskStatusEnumMap[instance.status]!,
  'priority': _$PriorityEnumMap[instance.priority]!,
};

const _$TaskStatusEnumMap = {
  TaskStatus.todo: 'todo',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.done: 'done',
};

const _$PriorityEnumMap = {
  Priority.high: 'high',
  Priority.medium: 'medium',
  Priority.low: 'low',
};

