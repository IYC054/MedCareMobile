import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/UI/Register/RegisterPage.dart';
import 'package:medcaremobile/services/AccountAPIService.dart';
import 'package:medcaremobile/services/AuthAPIService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/StorageService.dart';
import '../Home/Home.dart';
class Button extends StatefulWidget {
  final TextEditingController emailController;
  final String otp; // Nhận OTP từ InputWrapper

  const Button({Key? key, required this.emailController, required this.otp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ButtonState();
}
class _ButtonState extends State<Button>{
  bool _isLoading = false;
  final AccountAPIService apiService = AccountAPIService();
  final AuthAPIService authAPIService = AuthAPIService();
  Future<void> verifyOTP() async {
    setState(() => _isLoading = true);

    String email = widget.emailController.text;
    String otp = widget.otp;
    print("email $email");
    print("otp $otp");
    if (otp.length != 6) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP phải có 6 chữ số!"), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final response = await authAPIService.verifyOtp(email, otp);

      if (response.containsKey('success') && response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Xác thực thành công!"), backgroundColor: Colors.green),
        );
        // Điều hướng đến trang đăng kí
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                Registerpage(emailController: widget.emailController),
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Xác thực thất bại!"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi kết nối đến server!"), backgroundColor: Colors.red),
      );
    }

    setState(() => _isLoading = false);
  }
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : verifyOTP,
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
