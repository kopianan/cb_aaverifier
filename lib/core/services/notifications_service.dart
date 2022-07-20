import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

String channelKey = 'basic_channel';

class NotificationService {
  static Future<void> createRecoverReqeustBanner(
      Map<String, dynamic> customData) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().microsecond,
        channelKey: channelKey,
        groupKey: 'recover',
        body: customData['body'],
        title: customData['title'],
        payload: {
          'topics': customData['topics'],
          'address': customData['address'],
        },
      ),
    );
  }

  static Future<bool> initializeAwesomeNotification() async {
    final result = await AwesomeNotifications().initialize(
      'resource://drawable/notify',
      [
        NotificationChannel(
            channelKey: channelKey,
            channelName: "Basic Notification",
            importance: NotificationImportance.High,
            channelShowBadge: true,
            channelDescription: "Descriptions"),
      ],
    );

    return result;
  }

  static Future<void> createDkgNotificationBanner(
      Map<String, dynamic> customData) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().microsecond,
        channelKey: channelKey,
        groupKey: 'dkg',
        body: customData['body'],
        title: customData['title'],
        payload: {'topics': customData['topics']},
      ),
    );
  }

  static Future<void> createSignNotificationBanner(
      Map<String, dynamic> customData) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().microsecond,
        channelKey: channelKey,
        groupKey: 'sign',
        body: customData['body'],
        title: customData['title'],
        payload: {
          'topics': customData['topics'],
          'payload': customData['payload'],
          'txObject': customData['txObject'],
        },
      ),
    );
  }

  static Future<void> checkPermission(BuildContext context) async {
    final isAllow = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllow) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }
}
