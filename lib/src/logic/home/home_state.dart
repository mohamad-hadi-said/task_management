import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_management/src/model/task_model.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  factory HomeState({
    @Default(false) bool loading,
    @Default(false) bool error,
    String? errorMessage,
    List<TaskModel>? tasks,
  }) = _HomeState;

}
