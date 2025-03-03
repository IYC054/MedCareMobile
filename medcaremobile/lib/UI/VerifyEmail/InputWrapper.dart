import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/VerifyEmail/Button.dart';
import 'package:medcaremobile/UI/VerifyEmail/InputField.dart';
import 'package:medcaremobile/services/GoogleSignInService.dart';

class InputWrapper extends StatelessWidget {
  final TextEditingController emailController;

  const InputWrapper({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: InputField(emailController: emailController),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Button(emailController: emailController), // Đảm bảo nút hiển thị
          ),
          ElevatedButton(
            onPressed: () async {
              final userData = await Googlesigninservice.signInWithGoogle();
              if (userData != null) {
                print(
                    "Đăng nhập thành công: ${userData['name']} - Token: ${userData['token']}");
              } else {
                print("Đăng nhập thất bại");
              }
            },
            child: Text("Đăng nhập bằng Google"),
          ),
        ],
      ),
    );
  }
}
