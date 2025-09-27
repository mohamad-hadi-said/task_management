import 'package:task_management/src/repositories/task_repository.dart';
import 'package:task_management/src/model/task_model.dart';
import 'package:task_management/core/utils/enums.dart';

class SampleData {
  static Future<void> addSampleTasks(TaskRepository repository) async {
    try {
      // Check if tasks already exist
      final existingTasks = await repository.getAllTasks();
      if (existingTasks.isNotEmpty) {
      
        return;
      }

      // Sample task 1
      final task1 = TaskModel(
        id: 0,
        title: 'شراء البقالة',
        note: 'شراء الأغراض الأساسية من السوبر ماركت',
        dueTime: DateTime.now().copyWith(hour: 10, minute: 0),
        isDone: false,
        priority: Priority.high,
      );
      await repository.createTaskWithSubtasks(task1, [
        'شراء الخضروات',
        'شراء الفواكه',
        'شراء اللحوم',
        'شراء منتجات الألبان',
      ]);

      // Sample task 2
      final task2 = TaskModel(
        id: 0,
        title: 'حجز موعد',
        note: 'حجز موعد مع الطبيب للفحص الدوري',
        dueTime: DateTime.now().copyWith(hour: 11, minute: 30),
        isDone: false,
        priority: Priority.medium,
      );
      await repository.createTaskWithSubtasks(task2, [
        'البحث عن طبيب مناسب',
        'الاتصال بالعيادة',
        'تأكيد الموعد',
      ]);

      // Sample task 3
      final task3 = TaskModel(
        id: 0,
        title: 'دفع الفواتير',
        note: 'دفع فواتير الكهرباء والماء والإنترنت',
        dueTime: DateTime.now().copyWith(hour: 13, minute: 0),
        isDone: false,
        priority: Priority.low,
      );
      await repository.createTaskWithSubtasks(task3, [
        'دفع فاتورة الكهرباء',
        'دفع فاتورة الماء',
        'دفع فاتورة الإنترنت',
      ]);

      // Sample task 4
      final task4 = TaskModel(
        id: 0,
        title: 'اجتماع المشروع',
        note: 'اجتماع فريق العمل لمناقشة تقدم المشروع',
        dueTime: DateTime.now().copyWith(hour: 15, minute: 0),
        isDone: false,
        priority: Priority.high,
      );
      await repository.createTaskWithSubtasks(task4, [
        'إعداد العرض التقديمي',
        'مراجعة التقارير',
        'تجهيز قاعة الاجتماع',
      ]);

      // Sample task 5
      final task5 = TaskModel(
        id: 0,
        title: 'جلسة الجيم',
        note: 'ممارسة الرياضة في النادي الرياضي',
        dueTime: DateTime.now().copyWith(hour: 17, minute: 0),
        isDone: false,
        priority: Priority.medium,
      );
      await repository.createTaskWithSubtasks(task5, [
        'تجهيز ملابس الرياضة',
        'شرب الماء قبل التمرين',
        'الإحماء',
        'التمارين الأساسية',
      ]);

    
    } catch (e) {
      print('Error adding sample tasks: $e');
    }
  }
}
