import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const InputField({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<StatefulWidget> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final _formKey = GlobalKey<FormState>();
  String? _passwordError; // Biến lưu thông báo lỗi
  bool _isPasswordVisible = false;


  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: <Widget>[
    //     Container(
    //       padding: EdgeInsets.all(5),
    //       // decoration: BoxDecoration(
    //       //     border: Border(bottom: BorderSide(color: Colors.grey))),
    //       child: TextField(
    //         style: TextStyle(color: Colors.black87),
    //         controller: widget.emailController,
    //         enabled: false,
    //         // decoration: InputDecoration(
    //         //     hintText: "Nhập email ",
    //         //     hintStyle: TextStyle(color: Colors.grey),
    //         //     border: InputBorder.none
    //         // ),
    //         decoration: InputDecoration(
    //           border: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //           filled: true,
    //           fillColor: Colors.grey[200],  // Màu nền giống ảnh mẫu
    //         ),
    //       ),
    //     ),
    //     Container(
    //       padding: EdgeInsets.all(10),
    //       decoration: BoxDecoration(
    //           border: Border(bottom: BorderSide(color: Colors.grey))),
    //       child: TextField(
    //         controller: widget.passwordController,
    //         obscureText: true,
    //         decoration: InputDecoration(
    //             hintText: "Nhập mật khẩu",
    //             hintStyle: TextStyle(color: Colors.grey),
    //             border: InputBorder.none),
    //       ),
    //     )
    //   ],
    // );
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            child: TextFormField(
              style: TextStyle(color: Colors.black87),
              controller: widget.emailController,
              enabled: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: widget.passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
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
                    hintText: "Nhập mật khẩu",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ), // Hiển thị lỗi ở đây
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
