import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/AccountAPIService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/StorageService.dart';
import '../Home/Home.dart';
class Button extends StatefulWidget{
  final TextEditingController emailController;

  const Button({
    super.key,
    required this.emailController,
  });
  @override
  State<StatefulWidget> createState() => _ButtonState();

}
class _ButtonState extends State<Button>{
  bool _isLoading = false;
  final AccountAPIService apiService = AccountAPIService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: _isLoading ? null : _login,
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
            "Xác nhận",
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
