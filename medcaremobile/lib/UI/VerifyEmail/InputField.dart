import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController emailController;

  const InputField({
    super.key,
    required this.emailController,
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
                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}
