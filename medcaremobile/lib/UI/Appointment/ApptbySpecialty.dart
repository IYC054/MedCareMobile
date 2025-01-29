import 'package:flutter/material.dart';

class Apptbyspecialty extends StatefulWidget{
  Apptbyspecialty({super.key});
  
  @override
  State<StatefulWidget> createState() => ApptbyspecialtyState();
  
}
class ApptbyspecialtyState extends State<Apptbyspecialty> {
@override
  Widget build(BuildContext context) {
   return Scaffold(body: Center(child: Text("Khám theo chuyên khoa"),));
  }
}