import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiPage extends StatefulWidget{
  const NotiPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage>{
  Map payload = {};
  
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
    //for background and terminated state
    if (data is RemoteMessage){
      payload = data.data; 
    }
    //for foreground state
    if (data is NotificationResponse){
      payload = jsonDecode(data.payload!);

    }
    return Scaffold(
      appBar: AppBar(title: Text("Your Notification"),),
      body: Center(
        child: Text(payload.toString()),
      ),
    );
  }
  
}