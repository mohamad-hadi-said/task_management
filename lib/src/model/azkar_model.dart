import 'package:freezed_annotation/freezed_annotation.dart';

part 'azkar_model.g.dart';

@JsonSerializable()
class AzkarModel {
  int? id;
  String? text;
  int? repetitions;
  int? order;
  @JsonKey(name: 'is_favorite')
  bool? isFavorite;
  int? type;

  AzkarModel({
     this.id,
     this.text,
     this.repetitions,
     this.order,
     this.isFavorite,
     this.type,
  });

  Map<String, dynamic> toJson() => _$AzkarModelToJson(this);

  factory AzkarModel.fromJson(Map<String, dynamic> json) => _$AzkarModelFromJson(json);

}
