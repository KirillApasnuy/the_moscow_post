import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:the_moscow_post/data/controllers/firebase_controller.dart';
import 'package:the_moscow_post/firebase_options.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  if (message.notification != null) {
    print(
        "notification"); // Используйте Local Notifications для отображения уведомлений
    // (вам нужно будет создать и настроить функцию showNotification())
    // await showNotification(message);
  }
}

Future<void> subscribeToTopic(String topic) async {
  await FirebaseMessaging.instance.subscribeToTopic(topic);
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Отправьте уведомление здесь
    final firebaseController = FirebaseController();
    await firebaseController.sendNotification(
      // Токен устройства, на которое отправляем
      'Авто-уведомление',
      'Это автоматически отправленное уведомление каждые 6 часов.',
    );
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  subscribeToTopic("allDevices");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseController().initNotifications();
  late final PlatformWebViewControllerCreationParams params;
  if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    params = WebKitWebViewControllerCreationParams(
      allowsInlineMediaPlayback: true,
      mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    );
  } else {
    params = const PlatformWebViewControllerCreationParams();
  }

  final WebViewController controller =
      WebViewController.fromPlatformCreationParams(params);
// ···
  if (controller.platform is AndroidWebViewController) {
    AndroidWebViewController.enableDebugging(true);
    (controller.platform as AndroidWebViewController)
        .setMediaPlaybackRequiresUserGesture(false);
  }

  // Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: true, // Установите в false в продакшене
  // );
  // Workmanager().registerPeriodicTask(
  //   "notify_6_hours",
  //   "notify_6_hours",
  //   frequency: const Duration(hours: 6), // Каждый 6 часов
  // );
  runApp(const App());
}
