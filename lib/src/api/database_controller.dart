import 'package:task_management/src/repositories/task_repository.dart';
import 'package:task_management/src/model/task_model.dart';
import 'package:task_management/src/model/subtask_model.dart';
import 'package:task_management/core/utils/enums.dart';

class DatabaseController {
  final TaskRepository _taskRepository;

  DatabaseController({required TaskRepository taskRepository})
    : _taskRepository = taskRepository;

  // Example usage methods
  Future<void> initializeDatabase() async {
    try {
      // Test database connection by loading tasks
      await _taskRepository.getAllTasks();
      print('Database initialized successfully');

      // Add sample data if database is empty
      // await SampleData.addSampleTasks(_taskRepository);
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  // Create a sample task
  Future<int> createSampleTask() async {
    final task = TaskModel(
      id: 0, // Will be auto-generated
      title: 'مهمة تجريبية',
      note: 'هذه مهمة تجريبية لاختبار قاعدة البيانات',
      dueTime: DateTime.now().add(const Duration(days: 1)),
      isDone: false,
      priority: Priority.high,
    );

    final subtaskTitles = ['تحضير الملفات', 'مراجعة المحتوى', 'إرسال التقرير'];

    return await _taskRepository.createTaskWithSubtasks(task, subtaskTitles);
  }

  // Get all tasks with their subtasks
  Future<Map<int, List<SubtaskModel>>> getAllTasksWithSubtasks() async {
    final tasks = await _taskRepository.getAllTasks();
    final Map<int, List<SubtaskModel>> tasksWithSubtasks = {};

    for (final task in tasks) {
      final subtasks = await _taskRepository.getSubtasksByTaskId(task.id);
      tasksWithSubtasks[task.id] = subtasks;
    }

    return tasksWithSubtasks;
  }

  // Get task statistics
  Future<Map<String, int>> getTaskStatistics() async {
    final allTasks = await _taskRepository.getAllTasks();
    final completedTasks = await _taskRepository.getCompletedTasks();
    final pendingTasks = await _taskRepository.getPendingTasks();
    final overdueTasks = await _taskRepository.getOverdueTasks();

    return {
      'total': allTasks.length,
      'completed': completedTasks.length,
      'pending': pendingTasks.length,
      'overdue': overdueTasks.length,
    };
  }

  // Search tasks by title or note
  Future<List<TaskModel>> searchTasks(String query) async {
    return await _taskRepository.searchTasks(query);
  }

  // Get tasks by priority
  Future<List<TaskModel>> getTasksByPriority(Priority priority) async {
    return await _taskRepository.getTasksByPriority(priority);
  }

  // Mark task as completed
  Future<void> completeTask(int taskId) async {
    await _taskRepository.markTaskAsCompleted(taskId);
  }

  // Mark subtask as completed
  Future<void> completeSubtask(int subtaskId) async {
    await _taskRepository.markSubtaskAsCompleted(subtaskId);
  }

  // Get today's tasks
  Future<List<TaskModel>> getTodayTasks() async {
    return await _taskRepository.getTodayTasks();
  }

  // Get overdue tasks
  Future<List<TaskModel>> getOverdueTasks() async {
    return await _taskRepository.getOverdueTasks();
  }

  // Delete task and all its subtasks
  Future<void> deleteTaskCompletely(int taskId) async {
    await _taskRepository.deleteTask(taskId);
  }

  // Update task
  Future<void> updateTask(TaskModel task) async {
    await _taskRepository.updateTask(task);
  }

  // Add subtask to existing task
  Future<void> addSubtaskToTask(int taskId, String title) async {
    final subtask = SubtaskModel(
      id: 0, // Will be auto-generated
      taskId: taskId,
      title: title,
      isDone: false,
    );

    await _taskRepository.createSubtask(subtask);
  }

  // Get task completion percentage
  Future<int> getTaskCompletionPercentage(int taskId) async {
    return await _taskRepository.getTaskCompletionPercentage(taskId);
  }

  // Close database connection
  Future<void> close() async {
    await _taskRepository.close();
  }
}
