import 'package:flutter_test/flutter_test.dart';
import 'package:task_management/core/utils/enums.dart';
import 'package:task_management/src/model/task_model.dart';

void main() {
  group('TaskModel', () {
    final now = DateTime(2026, 8, 12, 10, 0);

    test('toMap and fromMap correctly serialize and deserialize', () {
      final task = TaskModel(
        id: 1,
        title: 'تجربة مهمة',
        note: 'ملاحظة',
        dueTime: now,
        status: TaskStatus.todo,
        priority: Priority.high,
      );

      final map = task.toMap();
      expect(map['title'], equals('تجربة مهمة'));
      expect(map['note'], equals('ملاحظة'));
      expect(map['due_time'], equals(now.toIso8601String()));
      expect(map['status'], equals(0)); // TaskStatus.todo.index
      expect(map['priority'], equals(0)); // Priority.high.index

      final mapWithId = {...map, 'id': 1};
      final deserialized = TaskModel.fromMap(mapWithId);
      expect(deserialized.id, equals(1));
      expect(deserialized.title, equals('تجربة مهمة'));
      expect(deserialized.note, equals('ملاحظة'));
      expect(deserialized.status, equals(TaskStatus.todo));
      expect(deserialized.priority, equals(Priority.high));
    });

    test('copyWith creates a new instance with updated fields', () {
      final task = TaskModel(
        id: 1,
        title: 'مهمة قديمة',
        note: 'ملاحظة',
        dueTime: now,
        status: TaskStatus.todo,
        priority: Priority.low,
      );

      final updatedTask = task.copyWith(
        title: 'مهمة جديدة',
        status: TaskStatus.done,
      );

      expect(updatedTask.id, equals(1));
      expect(updatedTask.title, equals('مهمة جديدة'));
      expect(updatedTask.status, equals(TaskStatus.done));
      expect(updatedTask.priority, equals(Priority.low));
    });

    test('arabicTitle returns correct localized titles', () {
      expect(TaskStatus.todo.arabicTitle, equals('يجب إنجازه'));
      expect(TaskStatus.inProgress.arabicTitle, equals('قيد العمل'));
      expect(TaskStatus.done.arabicTitle, equals('تم إنجازها'));
    });
  });
}
