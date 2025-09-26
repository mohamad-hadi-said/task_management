import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_management/src/model/task_model.dart';
import 'package:task_management/src/model/subtask_model.dart';
import 'package:task_management/core/utils/enums.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'task_management.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create tasks table
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        note TEXT NOT NULL,
        due_time TEXT NOT NULL,
        is_done INTEGER NOT NULL DEFAULT 0,
        priority INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Create subtasks table
    await db.execute('''
      CREATE TABLE subtasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        is_done INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (task_id) REFERENCES tasks (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_tasks_due_time ON tasks(due_time)');
    await db.execute('CREATE INDEX idx_tasks_is_done ON tasks(is_done)');
    await db.execute('CREATE INDEX idx_subtasks_task_id ON subtasks(task_id)');
    await db.execute('CREATE INDEX idx_subtasks_is_done ON subtasks(is_done)');
  }

  // Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // Tasks CRUD Operations
  Future<int> insertTask(TaskModel task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      orderBy: 'due_time ASC',
    );

    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  Future<TaskModel?> getTaskById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TaskModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateTask(TaskModel task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    // Delete subtasks first due to foreign key constraint
    await db.delete('subtasks', where: 'task_id = ?', whereArgs: [id]);
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<TaskModel>> getTasksByPriority(Priority priority) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'priority = ?',
      whereArgs: [priority.index],
      orderBy: 'due_time ASC',
    );

    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  Future<List<TaskModel>> getCompletedTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'is_done = ?',
      whereArgs: [1],
      orderBy: 'due_time DESC',
    );

    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  Future<List<TaskModel>> getPendingTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'is_done = ?',
      whereArgs: [0],
      orderBy: 'due_time ASC',
    );

    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  // Subtasks CRUD Operations
  Future<int> insertSubtask(SubtaskModel subtask) async {
    final db = await database;
    return await db.insert('subtasks', subtask.toMap());
  }

  Future<List<SubtaskModel>> getSubtasksByTaskId(int taskId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'subtasks',
      where: 'task_id = ?',
      whereArgs: [taskId],
      orderBy: 'id ASC',
    );

    return List.generate(maps.length, (i) {
      return SubtaskModel.fromMap(maps[i]);
    });
  }

  Future<SubtaskModel?> getSubtaskById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'subtasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return SubtaskModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateSubtask(SubtaskModel subtask) async {
    final db = await database;
    return await db.update(
      'subtasks',
      subtask.toMap(),
      where: 'id = ?',
      whereArgs: [subtask.id],
    );
  }

  Future<int> upsertSubtask(SubtaskModel subtask) async {
    final db = await database;

    // تحقق إذا السجل موجود
    final List<Map<String, dynamic>> result = await db.query(
      'subtasks',
      where: 'id = ?',
      whereArgs: [subtask.id],
    );
    if (result.isNotEmpty) {
      // موجود → تحديث
      return await db.update(
        'subtasks',
        subtask.toMap(),
        where: 'id = ?',
        whereArgs: [subtask.id],
      );
    } else {
      // غير موجود → إدخال جديد
      return await db.insert('subtasks', subtask.toMap());
    }
  }

  Future<int> deleteSubtask(int id) async {
    final db = await database;
    return await db.delete('subtasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<SubtaskModel>> getAllSubtasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'subtasks',
      orderBy: 'task_id ASC, id ASC',
    );

    return List.generate(maps.length, (i) {
      return SubtaskModel.fromMap(maps[i]);
    });
  }

  // Advanced queries
  Future<List<TaskModel>> getTasksWithSubtasks() async {
    final tasks = await getAllTasks();
    // Load subtasks for each task if needed
    // for (var task in tasks) {
    //   await getSubtasksByTaskId(task.id);
    //   // You can add a subtasks field to TaskModel if needed
    // }
    return tasks;
  }

  Future<int> getTaskCompletionPercentage(int taskId) async {
    final subtasks = await getSubtasksByTaskId(taskId);
    if (subtasks.isEmpty) return 0;

    final completedSubtasks = subtasks.where((s) => s.isDone).length;
    return ((completedSubtasks / subtasks.length) * 100).round();
  }

  Future<List<TaskModel>> searchTasks(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'title LIKE ? OR note LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'due_time ASC',
    );

    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }
}
