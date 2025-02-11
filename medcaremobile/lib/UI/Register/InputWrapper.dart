// import 'package:flutter/material.dart';
// import 'package:medcaremobile/UI/Register/Button.dart';
// import 'package:medcaremobile/UI/Register/InputField.dart';
//
// class InputWrapper extends StatefulWidget {
//   final TextEditingController emailController;
//
//   InputWrapper({required this.emailController, Key? key}) : super(key: key);
//
//   @override
//   _InputWrapperState createState() => _InputWrapperState();
// }
//
// class _InputWrapperState extends State<InputWrapper> {
//   Map<String, dynamic> userData = {};
//
//
//   @override
//   void initState() {
//     super.initState();
//     _handleUserDataChanged;
//   }
//
//   void _handleUserDataChanged(Map<String, dynamic> newUserData) {
//     setState(() {
//       userData = newUserData;
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(30),
//       child: Column(
//         children: <Widget>[
//           SizedBox(
//             height: 40,
//           ),
//           Container(
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(10)),
//             child: InputField(emailController: widget.emailController, onUserDataChanged: _handleUserDataChanged,),
//           ),
//           SizedBox(height: 40),
//           Button(userData: userData)
//         ],
//       ),
//     );
//   }
// }
