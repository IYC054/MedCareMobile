import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const InputField({
    super.key,
    required this.emailController,
    required this.passwordController,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
                hintText: "Nhập email ",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
          child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
                hintText: "Nhập mật khẩu",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
          ),
        )
      ],
    );
  }
}
