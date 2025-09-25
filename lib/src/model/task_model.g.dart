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
  isDone: json['is_done'] as bool? ?? false,
  priority:
      $enumDecodeNullable(_$PriorityEnumMap, json['priority']) ??
      Priority.medium,
);

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'note': instance.note,
  'due_time': instance.dueTime.toIso8601String(),
  'is_done': instance.isDone,
  'priority': _$PriorityEnumMap[instance.priority]!,
};

const _$PriorityEnumMap = {
  Priority.high: 'high',
  Priority.medium: 'medium',
  Priority.low: 'low',
};
