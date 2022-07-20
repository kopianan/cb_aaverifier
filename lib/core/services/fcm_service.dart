import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  static Future<void> subscribeFCM() async {
    final fcm = FirebaseMessaging.instance;
    final token = await FirebaseMessaging.instance.getToken();
    log(token.toString());
    await FirebaseMessaging.instance.subscribeToTopic('dkg');
    await FirebaseMessaging.instance.subscribeToTopic("sign");
    await FirebaseMessaging.instance.subscribeToTopic("offlinesign");
    await FirebaseMessaging.instance.subscribeToTopic("recoverRequest");
    log("Subscribe to DKG and OFFLINESIGN");
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
