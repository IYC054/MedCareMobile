import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/UI/Login/LoginPage.dart';
import 'package:medcaremobile/UI/VerifyOTP/VerifyOTPPage.dart';
import 'package:medcaremobile/services/AccountAPIService.dart';
import 'package:medcaremobile/services/AuthAPIService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/StorageService.dart';
import '../Home/Home.dart';
class Button extends StatefulWidget{
  final TextEditingController emailController;

  const Button({
    super.key,
    required this.emailController,
  });
  @override
  State<StatefulWidget> createState() => _ButtonState();

}
class _ButtonState extends State<Button>{
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
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(widget.emailController.text)) {
      setState(() => error = "Email không hợp lệ.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool exists = await accountAPIService.checkEmailExist(widget.emailController.text) ?? false;
      setState(() {
        exist = exists;
        next = true;
      });

      if (!exists) {
        bool otpSent = await authAPIService.sendOTP(widget.emailController.text);
        if (otpSent) {
          setState(() => success = "OTP đã được gửi.");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP sent successful!")),
          );
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VerifyOTPPage()),
            );
          }
        } else {
          setState(() => error = "Lỗi gửi OTP!");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to send OTP!")),
          );
        }
      } else{

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage(emailController: widget.emailController,)),
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
