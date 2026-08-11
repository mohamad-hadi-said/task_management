import 'package:task_management/src/model/subtask_model.dart';

abstract class SubTasksEvent {}

class LoadSubtasks extends SubTasksEvent {
  final int taskId;
  LoadSubtasks(this.taskId);
}

class AddSubtask extends SubTasksEvent {
  final SubtaskModel subtask;
  AddSubtask(this.subtask);
}

class UpdateSubtask extends SubTasksEvent {
  final SubtaskModel subtask;
  UpdateSubtask(this.subtask);
}

class DeleteSubtask extends SubTasksEvent {
  final int subtaskId;
  DeleteSubtask(this.subtaskId);
}

class ToggleSubtaskStatus extends SubTasksEvent {
  final int subtaskId;
  ToggleSubtaskStatus(this.subtaskId);
}
