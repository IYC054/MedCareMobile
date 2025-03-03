import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/ForgotPassword/ForgotPasswordPage.dart';
import 'package:medcaremobile/UI/Home/Home.dart';
import 'package:medcaremobile/UI/Login/Button.dart';
import 'package:medcaremobile/UI/Login/InputField.dart';
import 'package:medcaremobile/UI/Register/RegisterPage.dart';
import 'package:medcaremobile/UI/VerifyEmail/VerifyEmailPage.dart';
import 'package:medcaremobile/UI/VerifyOTP/VerifyOTPPage.dart';
import 'package:medcaremobile/services/GoogleSignInService.dart';

import '../../services/AuthAPIService.dart';

class InputWrapper extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const InputWrapper({
    super.key,
    required this.emailController,
    required this.passwordController,
  });
  @override
  State<StatefulWidget> createState() => _InputWrapperState();
}

class _InputWrapperState extends State<InputWrapper> {
  final AuthAPIService authAPIService = AuthAPIService();
  bool _isLoading = false;
  Future<void> handleSendOTP() async {
    bool otpSent =
        await authAPIService.forgotPassword(widget.emailController.text);
    if (otpSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Gửi OTP thành công!"),
            backgroundColor: Colors.green),
      );
      if (mounted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                VerifyOTPPage(
                    emailController: widget.emailController, forgotPass: true),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Gửi OTP thất bại!"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: InputField(
              emailController: widget.emailController,
              passwordController: widget.passwordController,
            ),
          ),
          SizedBox(height: 40),
          TextButton(
              onPressed: handleSendOTP,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text("Quên mật khẩu? Gửi OTP",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ))),
          SizedBox(
            height: 40,
          ),
          Button(
              emailController: widget.emailController,
              passwordController: widget.passwordController),
          SizedBox(
            height: 10,
          ),
          
        ],
      ),
    );
  }
}
