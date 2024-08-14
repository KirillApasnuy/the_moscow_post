import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:onesignal_flutter/onesignal_flutter.dart";
import "package:the_moscow_post/firebase_options.dart";

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("dbbf6c84-4d6e-45cf-b88c-e7bb5c9766e2");
  OneSignal.Notifications.requestPermission(true);
  runApp(const App());
}
