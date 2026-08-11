# Task Management Database Usage Guide

## Overview
This project includes a local SQLite database for managing tasks and subtasks with full CRUD operations.

## Database Structure

### Tables

#### 1. Tasks Table
```sql
CREATE TABLE tasks(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  note TEXT NOT NULL,
  due_time TEXT NOT NULL,
  is_done INTEGER NOT NULL DEFAULT 0,
  priority INTEGER NOT NULL DEFAULT 1
)
```

#### 2. Subtasks Table
```sql
CREATE TABLE subtasks(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  task_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  is_done INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (task_id) REFERENCES tasks (id) ON DELETE CASCADE
)
```

## Usage Examples

### 1. Basic Setup
```dart
import 'package:task_management/injection_container.dart';
import 'package:task_management/src/api/database_controller.dart';

// Initialize dependencies
await configureDependencies();

// Get database controller
final dbController = sl<DatabaseController>();

// Initialize database
await dbController.initializeDatabase();
```

### 2. Creating Tasks
```dart
// Create a simple task
final task = TaskModel(
  id: 0, // Auto-generated
  title: 'Complete project',
  note: 'Finish the Flutter project',
  dueTime: DateTime.now().add(Duration(days: 3)),
  isDone: false,
  priority: Priority.high,
);

final taskId = await dbController.createTask(task);

// Create task with subtasks
final subtaskTitles = ['Design UI', 'Implement logic', 'Test app'];
final taskWithSubtasks = await dbController.createTaskWithSubtasks(task, subtaskTitles);
```

### 3. Reading Data
```dart
// Get all tasks
final allTasks = await dbController.getAllTasks();

// Get tasks by priority
final highPriorityTasks = await dbController.getTasksByPriority(Priority.high);

// Get today's tasks
final todayTasks = await dbController.getTodayTasks();

// Get overdue tasks
final overdueTasks = await dbController.getOverdueTasks();

// Search tasks
final searchResults = await dbController.searchTasks('project');

// Get task statistics
final stats = await dbController.getTaskStatistics();
print('Total tasks: ${stats['total']}');
print('Completed: ${stats['completed']}');
print('Pending: ${stats['pending']}');
```

### 4. Updating Tasks
```dart
// Update task
final updatedTask = TaskModel(
  id: taskId,
  title: 'Updated task title',
  note: 'Updated note',
  dueTime: DateTime.now().add(Duration(days: 5)),
  isDone: false,
  priority: Priority.medium,
);

await dbController.updateTask(updatedTask);

// Mark task as completed
await dbController.completeTask(taskId);
```

### 5. Managing Subtasks
```dart
// Add subtask to existing task
await dbController.addSubtaskToTask(taskId, 'New subtask title');

// Complete subtask
await dbController.completeSubtask(subtaskId);

// Get task completion percentage
final percentage = await dbController.getTaskCompletionPercentage(taskId);
print('Task completion: $percentage%');
```

### 6. Using with BLoC
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/src/logic/tasks/tasks_bloc.dart';

// In your widget
BlocProvider(
  create: (context) => sl<TasksBloc>()..add(LoadTasks()),
  child: YourTaskWidget(),
)

// In your widget
BlocBuilder<TasksBloc, TasksState>(
  builder: (context, state) {
    if (state is TasksLoading) {
      return CircularProgressIndicator();
    } else if (state is TasksLoaded) {
      return ListView.builder(
        itemCount: state.tasks.length,
        itemBuilder: (context, index) {
          final task = state.tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.note),
            trailing: Checkbox(
              value: task.isDone,
              onChanged: (_) {
                context.read<TasksBloc>().add(ToggleTaskStatus(task.id));
              },
            ),
          );
        },
      );
    } else if (state is TasksError) {
      return Text('Error: ${state.message}');
    }
    return Container();
  },
)

// Add new task
context.read<TasksBloc>().add(AddTask(newTask));

// Delete task
context.read<TasksBloc>().add(DeleteTask(taskId));

// Search tasks
context.read<TasksBloc>().add(SearchTasks(searchQuery));
```

### 7. Advanced Queries
```dart
// Get tasks with their subtasks
final tasksWithSubtasks = await dbController.getAllTasksWithSubtasks();

for (final entry in tasksWithSubtasks.entries) {
  final taskId = entry.key;
  final subtasks = entry.value;
  
  print('Task $taskId has ${subtasks.length} subtasks');
  for (final subtask in subtasks) {
    print('- ${subtask.title}: ${subtask.isDone ? 'Done' : 'Pending'}');
  }
}

// Filter tasks by status
final completedTasks = await dbController.getCompletedTasks();
final pendingTasks = await dbController.getPendingTasks();
```

## Priority Enum Values
- `Priority.high` = 0
- `Priority.medium` = 1  
- `Priority.low` = 2

## Database Features
- ✅ Automatic ID generation
- ✅ Foreign key constraints with CASCADE delete
- ✅ Indexes for better performance
- ✅ Full CRUD operations
- ✅ Search functionality
- ✅ Filtering by priority and status
- ✅ Task completion percentage calculation
- ✅ Overdue task detection
- ✅ Today's tasks filtering
- ✅ Task statistics

## Error Handling
All database operations include proper error handling. Make sure to wrap database calls in try-catch blocks:

```dart
try {
  await dbController.createTask(task);
} catch (e) {
  print('Error creating task: $e');
}
```

## Performance Tips
1. Use indexes for frequently queried columns
2. Implement pagination for large datasets
3. Use transactions for bulk operations
4. Close database connections when done
5. Use lazy loading for subtasks

## Migration
For future database schema changes, increment the version number in `DatabaseHelper._initDatabase()` and implement migration logic in the `onUpgrade` callback.
