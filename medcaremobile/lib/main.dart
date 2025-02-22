import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Home/Home.dart';
import 'package:medcaremobile/UI/Home/Homepage.dart';
import 'package:medcaremobile/UI/Login/LoginPage.dart';
import 'package:medcaremobile/UI/News/Newspage.dart';
import 'package:medcaremobile/UI/News/NotificationPage.dart';
import 'package:medcaremobile/UI/Profile/Profilepage.dart';
import 'package:medcaremobile/UI/VerifyEmail/VerifyEmailPage.dart';
import 'package:medcaremobile/services/IpNetwork.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
      '/news': (context) => VerifyEmailPage(),
      // '/promo': (context) => PromoScreen(),
      // '/guide': (context) => GuideScreen(),
    },
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      
      home: Home(),
    );
  }
}

