import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Register/InputWrapper.dart';
import 'package:medcaremobile/UI/Register/Header.dart';
class Registerpage extends StatelessWidget {
  Registerpage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
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
                    child: Inputwrapper())
              ],
            ),
          ),
        ));
  }
}
