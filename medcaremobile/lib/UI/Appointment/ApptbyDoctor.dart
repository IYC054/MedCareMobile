import 'package:flutter/material.dart';

class Apptbydoctor extends StatefulWidget{
  Apptbydoctor({super.key});
  
  @override
  State<StatefulWidget> createState() => ApptbydoctorState();
  
}
class ApptbydoctorState extends State<Apptbydoctor> {
@override
  Widget build(BuildContext context) {
   return Scaffold(body: Center(child: Text("Khám theo bác sĩ"),));
  }
}