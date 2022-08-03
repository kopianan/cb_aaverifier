import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  static Future<void> subscribeFCM() async {
    final fcm = FirebaseMessaging.instance;
    final token = await FirebaseMessaging.instance.getToken();
    log(token.toString());
    log("TRYING TO SUBSCRIBE");
    try {
      await fcm.subscribeToTopic("dkg");
      await fcm.subscribeToTopic("sign");
      await fcm.subscribeToTopic("offlinesign");
      await fcm.subscribeToTopic("recoverRequest");
    } catch (e) {
      log(e.toString());
    }

    log("Subscribed Topic");
  }

  Future<void> createRecoverRequest() async {
    final _dio = Dio();

    final _result = await _dio.post("https://fcm.googleapis.com/fcm/send",
        options: Options(headers: {
          'Authorization':
              'key=AAAAxrAHhc8:APA91bH8FtThi1hAitao-qKObdhPi3rD4xaoy0PWFzqagXPHL1g6PgIvpKA1OTrY3tr8RN3T_f0kbWOAXEk5dgNjB0NgfGx_G2x6H5_9CvII1_pPdSI-qMQ_AKMQYqJLy2GUWayzVKZR'
        }),
        data: {
          "to": "/topics/recoverRequest",
          "data": {
            "title": "Recover Request",
            "body":
                "User's device request for Recover their wallet proccess...",
            "topics": "recoverRequest",
          }
        });
  }
}
