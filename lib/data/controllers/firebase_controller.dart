import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:the_moscow_post/data/controllers/news_controller.dart';
import 'package:the_moscow_post/data/models/news.dart';
import 'package:the_moscow_post/data/repositories/repository.dart';
import 'package:the_moscow_post/screens/details/news_details.dart';

class FirebaseController {
  late String token;

  Future<void> initNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.getToken().then((tok) => print(tok));
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false, // Required to display a heads up notification
      badge: true,
      sound: false,
    );
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      // description
      importance: Importance.max,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var notification = message.notification;
      var android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: "logo",
                // other properties...
              ),
            ));
      }
    });
  }

  Future<void> sendNotification(String title, String body) async {
    const String serverKey =
        'BE9_PxMoc-AXcGwxbAjH5HAOvMAsfC0d-1my5YxmtmI0Y6cV6esK0M2QLwhMf6tx-h5T2LIy-r2_W4uXeHN8iGw'; // Замените на ваш ключ сервера FCM
    final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final payload = {
      'to': token,
      'notification': {
        'title': title,
        'body': body,
      },
      'data': {
        'key': 'value', // Дополнительные данные, если есть
      },
    };

    try {
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: headers,
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully: ${response.body}');
      } else {
        print(
            'Failed to send notification: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    NewsController newsController = NewsController(Repository());
    late News news;
    if (message == null) return;
    if (message.data["id"] != null) {
      newsController
          .fetchNewsId(message.data["id"])
          .then((fetchNews) => news = fetchNews);

      Navigator.push("/notification" as BuildContext,
          MaterialPageRoute(builder: (context) {
        return NewsDetails(
          news: news,
          numberItem: 0,
          listNews: [news],
        );
      }));
    }
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
