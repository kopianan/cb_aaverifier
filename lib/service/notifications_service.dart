import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<bool> initializeAwesomeNotification() async {
    final result =
        await AwesomeNotifications().initialize('resource://drawable/notify', [
      NotificationChannel(
          channelKey: "basic_channel",
          channelName: "Basic Notification",
          importance: NotificationImportance.High,
          channelShowBadge: true,
          channelDescription: "Descriptions")
    ]);

    return result;
  }

  static void checkPermission(BuildContext context) async {
    final isAllow = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllow) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }
}
