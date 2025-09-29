import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/src/logic/subtasks/subtascks_state.dart';
import 'package:task_management/src/logic/subtasks/subtasks_event.dart';
import 'package:task_management/src/repositories/task_repository.dart';

// Bloc
class SubtasksBloc extends Bloc<SubTasksEvent, SubTasksState> {
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
    Emitter<SubTasksState> emit,
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
    Emitter<SubTasksState> emit,
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
    Emitter<SubTasksState> emit,
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
    Emitter<SubTasksState> emit,
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
    Emitter<SubTasksState> emit,
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
