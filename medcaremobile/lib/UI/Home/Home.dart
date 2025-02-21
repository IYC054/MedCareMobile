import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Home/CameraPage.dart';
import 'package:medcaremobile/UI/Home/Chat_screen.dart';
import 'package:medcaremobile/UI/Home/Homepage.dart';
import 'package:medcaremobile/UI/Login/LoginPage.dart';
import 'package:medcaremobile/UI/News/Newspage.dart';
import 'package:medcaremobile/UI/News/NotificationPage.dart';
import 'package:medcaremobile/UI/Profile/ProfilePage.dart';
import 'package:medcaremobile/UI/Register/RegisterPage.dart';
import 'package:medcaremobile/UI/VerifyEmail/VerifyEmailPage.dart';
import 'package:medcaremobile/services/StorageService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;

  bool isLoggedIn = false;
  // Future<void> checkLoginStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  //   });
  // }
  @override
  void initState() {
    super.initState();
    print("🔹 isLoggedIn: $isLoggedIn");
    checkLoginStatus();
  }

  /// Kiểm tra trạng thái đăng nhập
  Future<void> checkLoginStatus() async {
    String? token = await StorageService.getToken(); // 🔹 Dùng `await` để lấy giá trị thực
    setState(() {
      isLoggedIn = token != null && token.isNotEmpty;
    });

    print("🔹 Token nhận được: $token"); // ✅ Debug token
    print("🔹 isLoggedIn: $isLoggedIn");
  }

  final pages = [
    Homepage(),
    NewspagePage(),
    Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (pageIndex == 2 && !isLoggedIn) ? VerifyEmailPage() : pages[pageIndex],
        bottomNavigationBar: CurvedNavigationBar(
          index: pageIndex < pages.length ? pageIndex : 0,
          onTap: (index) {
            setState(() {
              pageIndex = index;
              checkLoginStatus();
            });
          },
          items: [
            CurvedNavigationBarItem(
              child: Icon(Icons.home_outlined),
              label: 'Trang chủ',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.newspaper),
              label: 'Tin tức',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.perm_identity),
              label: 'Cá nhân',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(),));
        }, child: Icon(Icons.chat),),
        );
  }
}
