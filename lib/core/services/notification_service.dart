import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:task_management/core/theme/azkar_theme.dart';

class NotificationService {
  static const String _channelKey = 'azkar_channel';
  static const String _channelName = 'إشعارات أذكار';
  static const String _channelDescription = 'تنبيهات أذكار';

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
