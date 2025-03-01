import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/AccountAPIService.dart';
import 'package:medcaremobile/services/FirestoreService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../services/StorageService.dart';
import '../Home/Home.dart';
import 'package:show_custom_snackbar/show_custom_snackbar.dart';

class Button extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const Button({
    super.key,
    required this.emailController,
    required this.passwordController,
  });
  @override
  State<StatefulWidget> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isLoading = false;
  final AccountAPIService apiService = AccountAPIService();

  @override
  void initState() {
    super.initState();
  }

  // /// Kiểm tra trạng thái đăng nhập
  // Future<void> checkLoginStatus() async {
  //   StorageService.clearToken();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('auth_token');
  //
  //   setState(() {
  //     isLoggedIn = token != null && token.isNotEmpty;
  //   });
  // }

  Future<void> _login() async {
    if (widget.passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: ShowCustomSnackBar(
          title: "Vui lòng nhập mật khẩu.",
          label: "",
          color: Colors.red,
          icon: Icons.remove_circle_outline,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
      return; // Không tiếp tục nếu mật khẩu không hợp lệ
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await apiService.checkLogin(
        widget.emailController.text,
        widget.passwordController.text,
      );
      FirestoreService.loginWithEmail(
          widget.emailController.text, widget.passwordController.text);
      if (data != null &&
          data.containsKey('result') &&
          data['result'] != null &&
          data['result'].containsKey('token') &&
          data['result']['token'] != null) {
        // final String token = data['result']['token'] as String;
        //
        // // Lưu token vào SharedPreferences
        // await StorageService.saveToken(token);
        // Lấy deviceToken của Firebase
        String? deviceToken = await FirebaseMessaging.instance.getToken();

        if (deviceToken != null) {
          print("Device Token: $deviceToken");

          // Lưu deviceToken vào Firestore
          await FirestoreService.saveUserToken(deviceToken);
        }

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: ShowCustomSnackBar(
            title: "Đăng nhập thành công.",
            label: "",
            color: Colors.green,
            icon: Icons.check_circle_outline,
          ),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ));

        // Điều hướng đến màn hình chính
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      } else {
        throw Exception("Invalid response from server. Token not found.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: ShowCustomSnackBar(
          title: "Đăng nhập thất bại.",
          label: "",
          color: Colors.red,
          icon: Icons.remove_circle_outline,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   height: 50,
    //   margin: EdgeInsets.symmetric(horizontal: 50),
    //   decoration: BoxDecoration(
    //       color: Colors.cyan,
    //       borderRadius: BorderRadius.circular(10)
    //   ),
    //   child: Center(
    //     child: Text("Đăng nhập", style: TextStyle(
    //         color: Colors.white,
    //         fontSize: 15,
    //         fontWeight: FontWeight.bold
    //     ),),
    //   ),
    // );
    return GestureDetector(
      onTap: _isLoading ? null : _login,
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
          color: _isLoading ? Colors.grey : Colors.cyan,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  "Đăng nhập",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
