import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/VerifyOTP/Header.dart';
import 'package:medcaremobile/UI/VerifyOTP/InputWrapper.dart';

class VerifyOTPPage extends StatefulWidget{
  final TextEditingController emailController;
  final forgotPass;
  const VerifyOTPPage({super.key, required this.emailController, required this.forgotPass});

  @override
  State<StatefulWidget> createState() => _VerifyOTPPageState();
  
}

class _VerifyOTPPageState extends State<VerifyOTPPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        // Dùng SingleChildScrollView để cuộn khi xuất hiện bàn phím
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [Colors.cyan, Colors.blueAccent]),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 80),
              Header(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: InputWrapper(
                  emailController: widget.emailController,
                    forgotPass: widget.forgotPass
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}