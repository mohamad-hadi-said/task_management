// States
import 'package:task_management/src/model/subtask_model.dart';

abstract class SubTasksState {}

class SubtasksInitial extends SubTasksState {}

class SubtasksLoading extends SubTasksState {}

class SubtasksLoaded extends SubTasksState {
  final List<SubtaskModel>? subtasks;

  SubtasksLoaded({required this.subtasks});
}

class SubtasksError extends SubTasksState {
  final String message;
  SubtasksError(this.message);
}