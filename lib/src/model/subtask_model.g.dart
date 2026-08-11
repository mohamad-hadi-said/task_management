// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubtaskModel _$SubtaskModelFromJson(Map<String, dynamic> json) => SubtaskModel(
  id: (json['id'] as num).toInt(),
  taskId: (json['task_id'] as num).toInt(),
  title: json['title'] as String,
  isDone: json['is_done'] as bool? ?? false,
);

Map<String, dynamic> _$SubtaskModelToJson(SubtaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task_id': instance.taskId,
      'title': instance.title,
      'is_done': instance.isDone,
    };
