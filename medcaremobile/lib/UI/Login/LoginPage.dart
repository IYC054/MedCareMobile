import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Login/Header.dart';
import 'package:medcaremobile/UI/Login/InputWrapper.dart';

class LoginPage extends StatefulWidget {
  final TextEditingController emailController;
  const LoginPage({super.key, required this.emailController,});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  // bool _isLoading = false;
  //
  // Future<void> _login() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   final response = await http.post(
  //     Uri.parse("http://173.16.16.52:8080/api/account/token"),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({
  //       'email': _emailController.text,
  //       'password': _passwordController.text,
  //     }),
  //   );
  //
  //   setState(() {
  //     _isLoading = false;
  //   });
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final token = data['token'];
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("Login successful! Token: $token"),
  //     ));
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("Login failed. Check your credentials."),
  //     ));
  //   }
  // }
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
                  passwordController: _passwordController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
