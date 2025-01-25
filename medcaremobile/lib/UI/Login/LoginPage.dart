import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Login/Header.dart';
import 'package:medcaremobile/UI/Login/InputWrapper.dart';

class Loginpage extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Loginpage({super.key});

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
                child: Inputwrapper(
                    phoneController: phoneController,
                    passwordController: passwordController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
