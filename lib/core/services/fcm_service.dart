import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  static Future<void> subscribeFCM() async {
    final fcm = FirebaseMessaging.instance;
    final token = await FirebaseMessaging.instance.getToken();
    log(token.toString());
    await FirebaseMessaging.instance.subscribeToTopic('dkg');
    await FirebaseMessaging.instance.subscribeToTopic("sign");
    await FirebaseMessaging.instance.subscribeToTopic("offlinesign");
    log("Subscribe to DKG and OFFLINESIGN");
  }
}
