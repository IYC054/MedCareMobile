import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Home/CameraPage.dart';
import 'package:medcaremobile/UI/Home/Homepage.dart';
import 'package:medcaremobile/UI/Login/LoginPage.dart';
import 'package:medcaremobile/UI/Profile/ProfilePage.dart';
import 'package:medcaremobile/UI/Register/RegisterPage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;

  final pages = [
    Homepage(),
    Loginpage(),
    CameraPage(),
    Registerpage(),
    Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[pageIndex],
        bottomNavigationBar: CurvedNavigationBar(
          index: pageIndex,
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          items: [
            CurvedNavigationBarItem(
              child: Icon(Icons.home_outlined),
              label: 'Trang chủ',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.medical_information),
              label: 'Đặt lịch',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.camera_alt),
              label: 'Quét QR',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.newspaper),
              label: 'News',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.perm_identity),
              label: 'Cá nhân',
            ),
          ],
        ));
  }
}
