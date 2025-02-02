import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Home/Home.dart';
import 'package:medcaremobile/UI/Login/LoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
      '/news': (context) => Loginpage(),
      // '/promo': (context) => PromoScreen(),
      // '/guide': (context) => GuideScreen(),
    },
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      
      home: Home()
    );
  }
}

