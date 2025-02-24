import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Home/Home.dart';
import 'package:medcaremobile/UI/Home/Homepage.dart';
import 'package:medcaremobile/UI/Login/LoginPage.dart';
import 'package:medcaremobile/UI/News/Newspage.dart';
import 'package:medcaremobile/UI/News/NotificationPage.dart';
import 'package:medcaremobile/UI/Notification/NotiPage.dart';
import 'package:medcaremobile/UI/Profile/Profilepage.dart';
import 'package:medcaremobile/UI/VerifyEmail/VerifyEmailPage.dart';
import 'package:medcaremobile/firebase_options.dart';
import 'package:medcaremobile/services/NotificationService.dart';

final navigatorKey = GlobalKey< NavigatorState>(); 

//function to listen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification receive in the background!!!");
  }
}

Future<void> getDeviceToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  try {
    String? token = await messaging.getToken();
    if (token != null) {
      print("FCM Token: $token"); // Kiểm tra xem token có được tạo hay không
    } else {
      print("❌ Không lấy được device token.");
    }
  } catch (e) {
    print("🔥 Lỗi khi lấy token: $e");
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await PushNotifications.init();
  await PushNotifications.localNotiInit();

  // Gọi hàm lấy token
  await getDeviceToken();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
       print("Backfround notification tapped!!!");
       navigatorKey.currentState!.pushNamed("/notification", arguments: message);
    }
  });

  //handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
    String payloadData = jsonEncode(message.data);
    print("Some notification receive in the foreground!!!");
    if(message.notification != null) {
      PushNotifications.showSimpleNotification(
        title: message.notification!.title!, 
        body: message.notification!.body!, 
        payload: payloadData);
    }
  });

  //for handling in terminated state
  final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if(message != null) {
    print("Launched notification from terminated state!!!");
    Future.delayed(Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed('/notification', arguments: message);

    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
      '/news': (context) => VerifyEmailPage(),
      '/notification': (context) => NotiPage()
      // '/notification': (context) => NotificationPage(),
      // '/promo': (context) => PromoScreen(),
      // '/guide': (context) => GuideScreen(),
    },
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      
      home: Home(),
    );
  }
}

