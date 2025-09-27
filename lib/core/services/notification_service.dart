import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:task_management/core/theme/azkar_theme.dart';

class NotificationService {
  static const String _channelKey = 'tasks_channel';
  static const String _channelName = 'إشعارات المهام';
  static const String _channelDescription = 'تنبيهات المهمة';

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
