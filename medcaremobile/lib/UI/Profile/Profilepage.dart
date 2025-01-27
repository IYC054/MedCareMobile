import 'package:flutter/material.dart';

class Profilepage extends StatefulWidget {
  Profilepage({super.key});
  @override
  State<StatefulWidget> createState() => ProfilepageState();
}

class ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Profile"),
      ),
    );
  }
}
