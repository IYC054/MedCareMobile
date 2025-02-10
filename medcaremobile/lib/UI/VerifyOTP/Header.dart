import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // SizedBox(height: 10,),
            Center(
              child: Text("MedCare", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 10,),
            Center(
              child: Text("Vui lòng nhập mã 6 số đã gửi đến email", style: TextStyle(color: Colors.white, fontSize: 20),),
            ),
          ],
        ));
  }
}
