import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Home/Home.dart';
import 'package:medcaremobile/UI/Login/Button.dart';
import 'package:medcaremobile/UI/Login/InputField.dart';
import 'package:medcaremobile/UI/Register/RegisterPage.dart';
class InputWrapper extends StatefulWidget{
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const InputWrapper({
    super.key,
    required this.emailController,
    required this.passwordController,
  });
  @override
  State<StatefulWidget> createState() => _InputWrapperState();

}
class _InputWrapperState extends State<InputWrapper> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: InputField(
              emailController: widget.emailController,
              passwordController: widget.passwordController,
            ),
          ),
          SizedBox(height: 40),
          Text(
            "Quên mật khẩu?",
            style: TextStyle(color: Colors.grey),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Registerpage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Text(
              "Chưa có tài khoản đăng ký?",
              style: TextStyle(color: Colors.blue),
              textAlign: TextAlign.center, // Căn giữa
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Button(
            emailController: widget.emailController,
            passwordController: widget.passwordController
          ),
        ],
      ),
    );
  }
}
