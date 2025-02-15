import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medcaremobile/UI/Login/LoginPage.dart';
import 'package:medcaremobile/services/AccountAPIService.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Register/Header.dart';

class ForgotPasswordPage extends StatefulWidget {
  final TextEditingController emailController;

  const ForgotPasswordPage({super.key, required this.emailController});

  @override
  State<StatefulWidget> createState() => _ForgotPasswordPageState();

}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  AccountAPIService accountAPIService = AccountAPIService();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_formKey.currentState!.validate()) {
        // Xử lý đăng ký ở đây
        print("Password: ${_passwordController.text}");
        print("Confirm Password: ${_confirmPasswordController.text}");
      }
      // try {
        setState(() => _isLoading = true);

        // var response = await accountAPIService.registerAccount(
        //   email: widget.emailController.text,
        //   password: _passwordController.text,
        // );

        // print("API Response: $response");

        // if (response.containsKey('result') && response['result'] != null) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text("Thay đổi mật khẩu thành công!"), backgroundColor: Colors.green),
        //   );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage(emailController: widget.emailController)),
          );
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text(response['message'] ?? "Thay đổi mật khẩu thất bại!"), backgroundColor: Colors.red),
      //     );
      //   }
      // } catch (e) {
      //   print("Error: $e");
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Lỗi kết nối đến server!"), backgroundColor: Colors.red),
      //   );
      // } finally {
      //   setState(() => _isLoading = false);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.cyan, Colors.blueAccent],
                  begin: Alignment.topCenter),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Header(),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: widget.emailController,
                              enabled: false,
                              // decoration: InputDecoration(
                              //     hintText: "Nhập email ",
                              //     hintStyle: TextStyle(color: Colors.grey),
                              //     border: InputBorder.none
                              // ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor:
                                Colors.grey[200], // Màu nền giống ảnh mẫu
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu',
                                suffixIcon: IconButton(
                                  icon: Icon(_isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              obscureText:
                              !_isPasswordVisible, // Ẩn/hiện mật khẩu
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu';
                                } else if (value.length < 6) {
                                  return 'Mật khẩu phải chứa ít nhất 6 ký tự';
                                } else if (!RegExp(
                                    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$')
                                    .hasMatch(value)) {
                                  return 'Mật khẩu phải có chữ hoa, chữ thường, số và ký tự đặc biệt';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu',
                                suffixIcon: IconButton(
                                  icon: Icon(_isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              obscureText: !_isConfirmPasswordVisible,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng xác nhận mật khẩu';
                                } else if (value != _passwordController.text) {
                                  return 'Mật khẩu không trùng khớp';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: GestureDetector(
                                onTap: _isLoading ? null : _submitForm,
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    color:
                                    _isLoading ? Colors.grey : Colors.cyan,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: _isLoading
                                        ? CircularProgressIndicator(
                                        color: Colors.white)
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}

