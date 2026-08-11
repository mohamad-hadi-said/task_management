// States
import 'package:task_management/src/model/subtask_model.dart';
import 'package:task_management/src/model/task_model.dart';

abstract class TasksState {}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<TaskModel> tasks;
  final List<SubtaskModel>? subtasks;
  final int? selectedTaskId;

  TasksLoaded({required this.tasks, this.subtasks, this.selectedTaskId});
}

class TasksError extends TasksState {
  final String message;
  TasksError(this.message);
}