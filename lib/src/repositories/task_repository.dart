import 'package:task_management/src/api/database_helper.dart';
import 'package:task_management/src/model/task_model.dart';
import 'package:task_management/src/model/subtask_model.dart';
import 'package:task_management/core/utils/enums.dart';

class TaskRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Task operations
  Future<int> createTask(TaskModel task) async {
    return await _databaseHelper.insertTask(task);
  }

  Future<List<TaskModel>> getAllTasks() async {
    return await _databaseHelper.getAllTasks();
  }

  Future<TaskModel?> getTaskById(int id) async {
    return await _databaseHelper.getTaskById(id);
  }

  Future<int> updateTask(TaskModel task) async {
    return await _databaseHelper.updateTask(task);
  }

  Future<int> deleteTask(int id) async {
    return await _databaseHelper.deleteTask(id);
  }

  Future<List<TaskModel>> getTasksByPriority(Priority priority) async {
    return await _databaseHelper.getTasksByPriority(priority);
  }

  Future<List<TaskModel>> getCompletedTasks() async {
    return await _databaseHelper.getCompletedTasks();
  }

  Future<List<TaskModel>> getPendingTasks() async {
    return await _databaseHelper.getPendingTasks();
  }

  Future<List<TaskModel>> searchTasks(String query) async {
    return await _databaseHelper.searchTasks(query);
  }

  // Subtask operations
  Future<int> createSubtask(SubtaskModel subtask) async {
    return await _databaseHelper.insertSubtask(subtask);
  }

  Future<List<SubtaskModel>> getSubtasksByTaskId(int taskId) async {
    return await _databaseHelper.getSubtasksByTaskId(taskId);
  }

  Future<SubtaskModel?> getSubtaskById(int id) async {
    return await _databaseHelper.getSubtaskById(id);
  }

  Future<int> updateSubtask(SubtaskModel subtask) async {
    return await _databaseHelper.updateSubtask(subtask);
  }
  Future<int> upsertSubtask(SubtaskModel subtask) async {
    return await _databaseHelper.upsertSubtask(subtask);
  }

  Future<int> deleteSubtask(int id) async {
    return await _databaseHelper.deleteSubtask(id);
  }

  Future<List<SubtaskModel>> getAllSubtasks() async {
    return await _databaseHelper.getAllSubtasks();
  }

  // Advanced operations
  Future<List<TaskModel>> getTasksWithSubtasks() async {
    return await _databaseHelper.getTasksWithSubtasks();
  }

  Future<int> getTaskCompletionPercentage(int taskId) async {
    return await _databaseHelper.getTaskCompletionPercentage(taskId);
  }

  // Utility methods
  Future<void> markTaskAsCompleted(int taskId) async {
    final task = await getTaskById(taskId);
    if (task != null) {
      final updatedTask = TaskModel(
        id: task.id,
        title: task.title,
        note: task.note,
        dueTime: task.dueTime,
        isDone: true,
        priority: task.priority,
      );
      await updateTask(updatedTask);
    }
  }

  Future<void> markTaskAsPending(int taskId) async {
    final task = await getTaskById(taskId);
    if (task != null) {
      final updatedTask = TaskModel(
        id: task.id,
        title: task.title,
        note: task.note,
        dueTime: task.dueTime,
        isDone: false,
        priority: task.priority,
      );
      await updateTask(updatedTask);
    }
  }

  Future<void> markSubtaskAsCompleted(int subtaskId) async {
    final subtask = await getSubtaskById(subtaskId);
    if (subtask != null) {
      final updatedSubtask = SubtaskModel(
        id: subtask.id,
        taskId: subtask.taskId,
        title: subtask.title,
        isDone: true,
      );
      await updateSubtask(updatedSubtask);
    }
  }

  Future<void> markSubtaskAsPending(int subtaskId) async {
    final subtask = await getSubtaskById(subtaskId);
    if (subtask != null) {
      final updatedSubtask = SubtaskModel(
        id: subtask.id,
        taskId: subtask.taskId,
        title: subtask.title,
        isDone: false,
      );
      await updateSubtask(updatedSubtask);
    }
  }

  // Create task with subtasks
  Future<int> createTaskWithSubtasks(
    TaskModel task,
    List<String> subtaskTitles,
  ) async {
    final taskId = await createTask(task);

    for (String title in subtaskTitles) {
      final subtask = SubtaskModel(
        id: 0, // Will be auto-generated
        taskId: taskId,
        title: title,
        isDone: false,
      );
      await createSubtask(subtask);
    }

    return taskId;
  }

  // Get overdue tasks
  Future<List<TaskModel>> getOverdueTasks() async {
    final now = DateTime.now();
    final allTasks = await getAllTasks();

    return allTasks
        .where((task) => !task.isDone && task.dueTime.isBefore(now))
        .toList();
  }

  // Get today's tasks
  Future<List<TaskModel>> getTodayTasks() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final allTasks = await getAllTasks();

    return allTasks
        .where(
          (task) =>
              task.dueTime.isAfter(today) && task.dueTime.isBefore(tomorrow),
        )
        .toList();
  }

  // Close database connection
  Future<void> close() async {
    await _databaseHelper.close();
  }
}
