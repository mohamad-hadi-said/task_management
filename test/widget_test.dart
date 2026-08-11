import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management/core/theme/azkar_theme.dart';
import 'package:task_management/core/utils/enums.dart';
import 'package:task_management/src/model/task_model.dart';
import 'package:task_management/src/view/widgets/task_card.dart';

void main() {
  group('TaskCard Widget Test', () {
    final sampleTask = TaskModel(
      id: 10,
      title: 'اختبار البطاقة',
      note: 'ملاحظة اختبارية',
      dueTime: DateTime.now().add(const Duration(hours: 2)),
      status: TaskStatus.todo,
      priority: Priority.high,
    );

    testWidgets('renders task title, note, status, and priority badge correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AzkarTheme.darkTheme,
          home: Scaffold(
            body: TaskCard(
              task: sampleTask,
            ),
          ),
        ),
      );

      expect(find.text('اختبار البطاقة'), findsOneWidget);
      expect(find.text('ملاحظة اختبارية'), findsOneWidget);
      expect(find.text('يجب إنجازه'), findsOneWidget);
      expect(find.text('عالية'), findsOneWidget);
    });

    testWidgets('shows checkmark when in selection mode and selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AzkarTheme.darkTheme,
          home: Scaffold(
            body: TaskCard(
              task: sampleTask,
              isSelectionMode: true,
              isSelected: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
