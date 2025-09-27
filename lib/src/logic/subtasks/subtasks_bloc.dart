import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/src/model/subtask_model.dart';
import 'package:task_management/src/repositories/task_repository.dart';

// Events
abstract class SubasksEvent {}

class LoadTasks extends SubasksEvent {}

class LoadSubtasks extends SubasksEvent {
  final int taskId;
  LoadSubtasks(this.taskId);
}

class AddSubtask extends SubasksEvent {
  final SubtaskModel subtask;
  AddSubtask(this.subtask);
}

class UpdateSubtask extends SubasksEvent {
  final SubtaskModel subtask;
  UpdateSubtask(this.subtask);
}

class DeleteSubtask extends SubasksEvent {
  final int subtaskId;
  DeleteSubtask(this.subtaskId);
}

class ToggleSubtaskStatus extends SubasksEvent {
  final int subtaskId;
  ToggleSubtaskStatus(this.subtaskId);
}

// States
abstract class SubtasksState {}

class SubtasksInitial extends SubtasksState {}

class SubtasksLoading extends SubtasksState {}

class SubtasksLoaded extends SubtasksState {
  final List<SubtaskModel>? subtasks;

  SubtasksLoaded({required this.subtasks});
}

class SubtasksError extends SubtasksState {
  final String message;
  SubtasksError(this.message);
}

// Bloc
class SubtasksBloc extends Bloc<SubasksEvent, SubtasksState> {
  final TaskRepository _taskRepository;

  SubtasksBloc({required TaskRepository taskRepository})
    : _taskRepository = taskRepository,
      super(SubtasksInitial()) {
    on<LoadSubtasks>(_onLoadSubtasks);
    on<AddSubtask>(_onAddSubtask);
    on<UpdateSubtask>(_onUpdateSubtask);
    on<DeleteSubtask>(_onDeleteSubtask);
    on<ToggleSubtaskStatus>(_onToggleSubtaskStatus);
  }

  Future<void> _onLoadSubtasks(
    LoadSubtasks event,
    Emitter<SubtasksState> emit,
  ) async {
    try {
      emit(SubtasksLoading());
      final subtasks = await _taskRepository.getSubtasksByTaskId(event.taskId);
      emit(SubtasksLoaded(subtasks: subtasks));
    } catch (e) {
      emit(SubtasksError('فشل في تحميل المهام الفرعية: ${e.toString()}'));
    }
  }

  Future<void> _onAddSubtask(
    AddSubtask event,
    Emitter<SubtasksState> emit,
  ) async {
    try {
      await _taskRepository.createSubtask(event.subtask);

      // Reload subtasks for the task
      add(LoadSubtasks(event.subtask.taskId));
    } catch (e) {
      emit(SubtasksError('فشل في إضافة المهمة الفرعية: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateSubtask(
    UpdateSubtask event,
    Emitter<SubtasksState> emit,
  ) async {
    try {
      await _taskRepository.updateSubtask(event.subtask);

      // Reload subtasks for the task
      add(LoadSubtasks(event.subtask.taskId));
    } catch (e) {
      emit(SubtasksError('فشل في تحديث المهمة الفرعية: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteSubtask(
    DeleteSubtask event,
    Emitter<SubtasksState> emit,
  ) async {
    try {
      final subtask = await _taskRepository.getSubtaskById(event.subtaskId);
      if (subtask != null) {
        await _taskRepository.deleteSubtask(event.subtaskId);

        // Reload subtasks for the task
        add(LoadSubtasks(subtask.taskId));
      }
    } catch (e) {
      emit(SubtasksError('فشل في حذف المهمة الفرعية: ${e.toString()}'));
    }
  }

  Future<void> _onToggleSubtaskStatus(
    ToggleSubtaskStatus event,
    Emitter<SubtasksState> emit,
  ) async {
    try {
      final subtask = await _taskRepository.getSubtaskById(event.subtaskId);
      if (subtask != null) {
        if (subtask.isDone) {
          await _taskRepository.markSubtaskAsPending(event.subtaskId);
        } else {
          await _taskRepository.markSubtaskAsCompleted(event.subtaskId);
        }

        // Reload subtasks for the task
        add(LoadSubtasks(subtask.taskId));
      }
    } catch (e) {
      emit(SubtasksError('فشل في تغيير حالة المهمة الفرعية: ${e.toString()}'));
    }
  }
}
