import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Login/Button.dart';
import 'package:medcaremobile/UI/Login/InputField.dart';

class Inputwrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(30),
    child: Column(
      children: <Widget>[
        SizedBox(height: 40,),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Inputfield(),
        ),
        SizedBox(height: 40),
        Text("Quên mật khẩu?", style: TextStyle(color: Colors.grey),),
        Text("Chưa có tài khoản đăng ký?", style: TextStyle(color: Colors.blue),),
        SizedBox(height: 40,),
        Button()
      ],
    ),);
  }
}