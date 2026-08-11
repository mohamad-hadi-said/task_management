import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:task_management/core/theme/azkar_theme.dart';
import 'package:task_management/injection_container.dart';
import 'package:task_management/src/logic/tasks/tasks_bloc.dart';
import 'package:task_management/src/logic/tasks/tasks_event.dart';

class NotificationService {
  static const String _channelKey = 'tasks_channel';
  static const String _channelName = 'تذكيرات المهام';
  static const String _channelDescription = 'إشعارات تذكير بالمهام';

  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      // null => Default app icon
      null,
      [
        NotificationChannel(
          channelKey: _channelKey,
          channelName: _channelName,
          channelDescription: _channelDescription,
          defaultColor: AzkarTheme.primaryColor,
          ledColor: AzkarTheme.primaryColor,
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
          channelShowBadge: true,
        ),
      ],
      debug: false,
    );
  }

  static Future<void> ensurePermission() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<void> cancelAllScheduled() async {
    try {
      await AwesomeNotifications().cancelAllSchedules();
    } catch (_) {}
  }
}

Future<void> scheduleTaskNotification(
  int id,
  String title,
  String body,
  DateTime dateTime,
) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'tasks_channel',
      title: title,
      body: body,
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'DONE_TASK_$id',
        label: 'إنجاز',
        color: const Color(0xFF4A90E2),
      ),
      NotificationActionButton(
        key: 'IGNORE_TASK_$id',
        label: 'تجاهل',
        color: const Color(0xFF2C2C2C),
      ),
    ],
    schedule: NotificationCalendar(
      year: dateTime.year,
      month: dateTime.month,
      day: dateTime.day,
      hour: dateTime.hour,
      minute: dateTime.minute,
      second: 0,
      millisecond: 0,
      repeats: false,
    ),
  );
}

Future<void> updateTask(
  int id,
  String title,
  String body,
  DateTime dateTime,
) async {
  await AwesomeNotifications().cancel(id);
  await scheduleTaskNotification(id, title, body, dateTime);
}

Future<void> cancelTaskNotification(int id) async {
  await AwesomeNotifications().cancel(id);
}

Future<void> listenToActions(receivedAction) async {
  final key = receivedAction.buttonKeyPressed;
  if (key.startsWith('DONE_TASK_')) {
    final id = int.tryParse(key.replaceFirst('DONE_TASK_', ''));
    if (id != null) {
      sl<TasksBloc>().add(ToggleTaskStatus(id));
    }
  } else if (key.startsWith('IGNORE_TASK_')) {
    final id = int.tryParse(key.replaceFirst('IGNORE_TASK_', ''));
    if (id != null) {
      await cancelTaskNotification(id);
    }
  }
}
