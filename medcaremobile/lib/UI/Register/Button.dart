import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medcaremobile/services/AccountAPIService.dart';


class Button extends StatefulWidget {
  final Map<String, dynamic> userData;

  Button({required this.userData, Key? key}) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  void _submitData() {
    print(widget.userData); // Debug xem có dữ liệu không
  }

  bool _isLoading = false;
  AccountAPIService accountAPIService = AccountAPIService();
  void _register() async {
    if (widget.userData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Vui lòng điền đầy đủ thông tin")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var result = await accountAPIService.register(widget.userData, null);

      if (result["success"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đăng ký thành công!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(" Đăng ký thất bại: ${result["message"]}")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi gửi yêu cầu: $error")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _submitData,
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
          color: _isLoading ? Colors.grey : Colors.cyan,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: _isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
            "Đăng ký",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}