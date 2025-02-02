import 'package:flutter/material.dart';

class Newspage extends StatefulWidget {
  Newspage({super.key});
  @override
  State<StatefulWidget> createState() => NewspageState();
}

class NewspageState extends State<Newspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Tin tức"),
      ),
    );
  }
}
