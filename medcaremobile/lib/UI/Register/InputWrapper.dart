import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Register/Button.dart';
import 'package:medcaremobile/UI/Register/InputField.dart';

class Inputwrapper extends StatelessWidget {
  const Inputwrapper({
    super.key,
  });
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
            child: Inputfield(),
          ),
          SizedBox(height: 40),
          Button()
        ],
      ),
    );
  }
}
