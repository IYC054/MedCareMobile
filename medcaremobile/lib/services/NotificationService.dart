import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medcaremobile/main.dart';
import 'package:medcaremobile/services/AuthAPIService.dart';
import 'package:medcaremobile/services/FirestoreService.dart';
import 'package:medcaremobile/services/StorageService.dart'; 

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance; 

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); //

  //request notification permission
  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    //get device fcm token
    // final token = await _firebaseMessaging.getToken();
    // print("Device Token: $token");
  }
  
  static Future getDeviceFcmToken() async {
    final token = await _firebaseMessaging.getToken();
    print("Device Token: $token");
    
    bool isUserLoggedIn = await FirestoreService.isLoggedIn();
    if (isUserLoggedIn) {
      await FirestoreService.saveUserToken(token!);
      print("Saved to Firestore: $token");
    }
    _firebaseMessaging.onTokenRefresh.listen((event) async {
      if (isUserLoggedIn) {
        await FirestoreService.saveUserToken(token!);
        print("Saved to Firestore: $token");
      }
    });
  }

  //initialize local notification 
  static Future localNotiInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_android',
       
    );
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid
    );

      //request android notification permission for Android 13 or above
    _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
    _flutterLocalNotificationsPlugin.initialize(initializationSettings, 
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap
    );
  }

  //on tap notification in foreground
  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!.pushNamed('/notification', arguments: notificationResponse);
  }
  //show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload
  }) async{
    const AndroidNotificationDetails androidNotificationDetails = 
    AndroidNotificationDetails(
      'channelid',
      'channelname',
      channelDescription: 'MedCare',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher'
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: payload);
  }
 
}