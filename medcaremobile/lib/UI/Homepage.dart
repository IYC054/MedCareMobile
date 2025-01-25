import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});
  
  @override
  State<StatefulWidget> createState() => HomepageState();
  
}
class HomepageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: Text("Home"),
    ),
   );
  }
  
}