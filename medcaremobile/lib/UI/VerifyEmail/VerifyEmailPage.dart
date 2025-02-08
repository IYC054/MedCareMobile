import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/VerifyEmail/Header.dart';
import 'package:medcaremobile/UI/VerifyEmail/InputWrapper.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<StatefulWidget> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height, // Fix lỗi NaN height
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [Colors.cyan, Colors.blueAccent],
            ),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0), // Fix lỗi NaN
              SizedBox(height: 180, child: Header()), // Định nghĩa chiều cao
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20), // Thêm padding
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: InputWrapper(
                    emailController: _emailController,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
