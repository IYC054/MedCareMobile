import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/VerifyOTP/Button.dart';
import 'package:medcaremobile/UI/VerifyOTP/InputField.dart';
import 'package:medcaremobile/services/AuthAPIService.dart';
class InputWrapper extends StatefulWidget {
  final TextEditingController emailController;
  final forgotPass;
  const InputWrapper({super.key, required this.emailController, required this.forgotPass});
  // const InputWrapper({Key? key, required this.emailController}) : super(key: key);

  @override
  _InputWrapperState createState() => _InputWrapperState();
}
class _InputWrapperState extends State<InputWrapper> {
  String otp = "";
  int secondsRemaining = 60;
  bool _isLoading = false;
  String? errorMessage;
  String? successMessage;
  bool nextStep = false;
  Timer? timer;

  AuthAPIService authAPIService = AuthAPIService();
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  Future<void> resendOTP() async {
    setState(() => _isLoading = true);
    try {
      if (!widget.forgotPass) {
        bool otpSent = await authAPIService.sendOTP(widget.emailController.text);
        if (otpSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gửi OTP thành công!"), backgroundColor: Colors.green),
          );

          if (mounted) {
            setState(() {
              secondsRemaining = 60; // Reset lại thời gian đếm ngược
              timer?.cancel(); // Hủy timer cũ (nếu có)
              timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if (secondsRemaining > 0) {
                  setState(() {
                    secondsRemaining--;
                  });
                } else {
                  timer.cancel();
                }
              });
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gửi OTP thất bại!"), backgroundColor: Colors.red),
          );
        }
      } else {
        bool otpForgotPassSent = await authAPIService.forgotPassword(
            widget.emailController.text);
        if (otpForgotPassSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gửi OTP để đổi mật khẩu thành công!"),
                backgroundColor: Colors.green),
          );
          if (mounted) {
            setState(() {
              secondsRemaining = 60; // Reset lại thời gian đếm ngược
              timer?.cancel(); // Hủy timer cũ (nếu có)
              timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if (secondsRemaining > 0) {
                  setState(() {
                    secondsRemaining--;
                  });
                } else {
                  timer.cancel();
                }
              });
            });
          }
        }
      }
    } catch (e) {
      print("Lỗi trong handleCheckEmail: $e");
    } finally {
      setState(() => _isLoading = false);
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
              onOtpChanged: (newOtp) {
                setState(() => otp = newOtp); // Cập nhật OTP khi nhập
              },
            ),
          ),
          SizedBox(height: 20),
          secondsRemaining > 0
              ? Text("Gửi lại mã OTP sau 00:${secondsRemaining.toString().padLeft(2, '0')}s")
              : TextButton(onPressed: resendOTP, child: Text("Gửi lại", style: TextStyle(
            color: Colors.blue,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )
          )
          ),
          SizedBox(
            height: 40,
          ),
          Button(
            emailController: widget.emailController,
            otp: otp, // Truyền OTP vào Button
            forgotPass: widget.forgotPass
          ),
        ],
      ),
    );
  }
}
