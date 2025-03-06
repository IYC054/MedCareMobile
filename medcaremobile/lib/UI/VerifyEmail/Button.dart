import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/UI/Login/LoginPage.dart';
import 'package:medcaremobile/UI/Register/RegisterPage.dart';
import 'package:medcaremobile/UI/VerifyOTP/VerifyOTPPage.dart';
import 'package:medcaremobile/services/AccountAPIService.dart';
import 'package:medcaremobile/services/AuthAPIService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/StorageService.dart';
import '../Home/Home.dart';

class Button extends StatefulWidget {
  final TextEditingController emailController;

  const Button({
    super.key,
    required this.emailController,
  });
  @override
  State<StatefulWidget> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isLoading = false;

  final AccountAPIService accountAPIService = AccountAPIService();
  final AuthAPIService authAPIService = AuthAPIService();

  bool next = false;
  bool exist = false;
  String error = "";
  String success = "";
  Future<void> handleCheckEmail() async {
    if (widget.emailController.text.isEmpty) {
      setState(() => error = "Email không thể để trống.");
      return;
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
        .hasMatch(widget.emailController.text)) {
      setState(() => error = "Email không hợp lệ.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool exists = await accountAPIService
              .checkEmailExist(widget.emailController.text) ??
          false;
      setState(() {
        exist = exists;
        next = true;
      });

      if (!exists) {
        // bool otpSent =
        //     await authAPIService.sendOTP(widget.emailController.text);
        // if (otpSent) {
        //   setState(() => success = "OTP đã được gửi.");
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //         content: Text("Gửi OTP thành công!"),
        //         backgroundColor: Colors.green),
        //   );
          if (mounted) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    RegisterPage(emailController: widget.emailController),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          }
        } 
        // else {
        //   setState(() => error = "Lỗi gửi OTP!");
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //         content: Text("Gửi OTP thất bại!"),
        //         backgroundColor: Colors.red),
        //   );
        // }
      else {
        if (mounted) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  LoginPage(emailController: widget.emailController),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        }
      }
    } catch (e) {
      print("Lỗi trong handleCheckEmail: $e");
      setState(() => error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : handleCheckEmail,
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
                  "Xác nhận",
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
