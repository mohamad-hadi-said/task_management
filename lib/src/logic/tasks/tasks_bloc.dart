import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/core/services/notification_service.dart';
import 'package:task_management/src/model/task_model.dart';
import 'package:task_management/src/model/subtask_model.dart';
import 'package:task_management/src/repositories/task_repository.dart';
import 'package:task_management/core/utils/enums.dart';

// Events
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

// States
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

// Bloc
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TaskRepository _taskRepository;

  TasksBloc({required TaskRepository taskRepository})
    : _taskRepository = taskRepository,
      super(TasksInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskStatus>(_onToggleTaskStatus);
    on<SearchTasks>(_onSearchTasks);
    on<FilterTasksByPriority>(_onFilterTasksByPriority);
    on<FilterTasksByStatus>(_onFilterTasksByStatus);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TasksState> emit) async {
    try {
      emit(TasksLoading());
      final tasks = await _taskRepository.getAllTasks();

      emit(TasksLoaded(tasks: tasks));
    } catch (e) {
      emit(TasksError('فشل في تحميل المهام: ${e.toString()}'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    try {
      if (event.subtaskTitles != null && event.subtaskTitles!.isNotEmpty) {
        await _taskRepository.createTaskWithSubtasks(
          event.task,
          event.subtaskTitles!,
        );
      } else {
        await _taskRepository.createTask(event.task);
      }
      scheduleTaskNotification(
        event.task.id,
        event.task.title,
        event.task.note ?? 'لديك مهمة مجدولة الآن.',
        event.task.dueTime,
      );
      // Reload tasks
      add(LoadTasks());
    } catch (e) {
      emit(TasksError('فشل في إضافة المهمة: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    try {

      await _taskRepository.updateTask(event.task);
      updateTask(
        event.task.id,
        event.task.title,
        event.task.note ?? 'لديك مهمة مجدولة الآن.',
        event.task.dueTime,
      );
      // // Reload tasks
      add(LoadTasks());
    } catch (e) {
      emit(TasksError('فشل في تحديث المهمة: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    try {
      await _taskRepository.deleteTask(event.taskId);
      cancelTaskNotification(event.taskId);
      // Reload tasks
      add(LoadTasks());
    } catch (e) {
      emit(TasksError('فشل في حذف المهمة: ${e.toString()}'));
    }
  }

  Future<void> _onToggleTaskStatus(
    ToggleTaskStatus event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final task = await _taskRepository.getTaskById(event.taskId);
      if (task != null) {
        if (task.isDone) {
          await _taskRepository.markTaskAsPending(event.taskId);
        } else {
          await _taskRepository.markTaskAsCompleted(event.taskId);
        }

        // Reload tasks
        add(LoadTasks());
      }
    } catch (e) {
      emit(TasksError('فشل في تغيير حالة المهمة: ${e.toString()}'));
    }
  }

  Future<void> _onSearchTasks(
    SearchTasks event,
    Emitter<TasksState> emit,
  ) async {
    try {
      if (event.query.isEmpty) {
        add(LoadTasks());
      } else {
        final tasks = await _taskRepository.searchTasks(event.query);
        emit(TasksLoaded(tasks: tasks));
      }
    } catch (e) {
      emit(TasksError('فشل في البحث: ${e.toString()}'));
    }
  }

  Future<void> _onFilterTasksByPriority(
    FilterTasksByPriority event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final tasks = await _taskRepository.getTasksByPriority(event.priority);
      emit(TasksLoaded(tasks: tasks));
    } catch (e) {
      emit(TasksError('فشل في تصفية المهام: ${e.toString()}'));
    }
  }

  Future<void> _onFilterTasksByStatus(
    FilterTasksByStatus event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final tasks = event.isCompleted
          ? await _taskRepository.getCompletedTasks()
          : await _taskRepository.getPendingTasks();
      emit(TasksLoaded(tasks: tasks));
    } catch (e) {
      emit(TasksError('فشل في تصفية المهام: ${e.toString()}'));
    }
  }
}
