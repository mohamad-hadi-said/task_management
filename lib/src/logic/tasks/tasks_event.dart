// Events
import 'package:task_management/core/utils/enums.dart';
import 'package:task_management/src/model/task_model.dart';

abstract class TasksEvent {}

class LoadTasks extends TasksEvent {}

class AddTask extends TasksEvent {
  final TaskModel task;
  final List<String>? subtaskTitles;

  AddTask(this.task, {this.subtaskTitles});
}

class UpdateTask extends TasksEvent {
  final TaskModel task;

  UpdateTask({required this.task});
}

class DeleteTask extends TasksEvent {
  final int taskId;
  DeleteTask(this.taskId);
}

class ToggleTaskStatus extends TasksEvent {
  final int taskId;
  ToggleTaskStatus(this.taskId);
}

class SearchTasks extends TasksEvent {
  final String query;
  SearchTasks(this.query);
}

class FilterTasksByPriority extends TasksEvent {
  final Priority priority;
  FilterTasksByPriority(this.priority);
}

class FilterTasksByStatus extends TasksEvent {
  final bool isCompleted;
  FilterTasksByStatus(this.isCompleted);
}