// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'azkar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AzkarModel _$AzkarModelFromJson(Map<String, dynamic> json) => AzkarModel(
  id: (json['id'] as num?)?.toInt(),
  text: json['text'] as String?,
  repetitions: (json['repetitions'] as num?)?.toInt(),
  order: (json['order'] as num?)?.toInt(),
  isFavorite: json['is_favorite'] as bool?,
  type: (json['type'] as num?)?.toInt(),
);

Map<String, dynamic> _$AzkarModelToJson(AzkarModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'repetitions': instance.repetitions,
      'order': instance.order,
      'is_favorite': instance.isFavorite,
      'type': instance.type,
    };
