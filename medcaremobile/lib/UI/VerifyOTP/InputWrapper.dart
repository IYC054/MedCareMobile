import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/VerifyOTP/Button.dart';
import 'package:medcaremobile/UI/VerifyOTP/InputField.dart';
class InputWrapper extends StatefulWidget {
  final TextEditingController emailController;

  const InputWrapper({Key? key, required this.emailController}) : super(key: key);

  @override
  _InputWrapperState createState() => _InputWrapperState();
}
class _InputWrapperState extends State<InputWrapper> {
  String otp = "";
  int secondsRemaining = 60;
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;
  bool nextStep = false;
  Timer? timer;

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
          ),
        ],
      ),
    );
  }
}
