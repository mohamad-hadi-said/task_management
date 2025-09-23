import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_management/src/model/azkar_model.dart';

part 'azkar_state.freezed.dart';

@freezed
abstract class AzkarState with _$AzkarState {
  factory AzkarState({
    @Default(false) bool loading,
    @Default(false) bool error,
    String? errorMessage,
    @Default([]) List<AzkarModel> azkar,
    @Default(0) int currentCount,
    AzkarModel? currentZeker,
    DateTime? dateTime,
  }) = _AzkarState;

}
