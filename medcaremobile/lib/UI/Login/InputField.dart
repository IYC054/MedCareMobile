import 'package:flutter/material.dart';

class Inputfield extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController passwordController;

  const Inputfield({
    super.key,
    required this.phoneController,
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
            controller: phoneController,
            decoration: InputDecoration(
                hintText: "Enter your phone number",
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
                hintText: "Enter your password",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none),
          ),
        )
      ],
    );
  }
}
