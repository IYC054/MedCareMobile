import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<StatefulWidget> createState() => HomepageState();
}

class HomepageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(220, 253, 255, 1),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                RichText(
                    text: TextSpan(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        children: [
                      TextSpan(text: "Chào mừng bạn đến với "),
                      TextSpan(
                          text: "MedCare",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                    ])),
                SizedBox(
                  // height: 300,

                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 50,
                              mainAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        String text = "";
                        IconData icon = Icons.help;
                        String imagePath = "";
                        switch (index) {
                          case 0:
                            text = "Đặt Khám";
                            icon = Icons.calendar_month;
                            imagePath = "image/appointment.svg";

                            break;
                          case 1:
                            text = "Lịch sử đặt khám";
                            icon = Icons.accessible_sharp;
                            imagePath = "image/appointmentlist.svg";
                            break;
                        }
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1.0,
                                  style: BorderStyle.solid,
                                  color: Color.fromRGBO(194, 194, 194, 0.8))),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                imagePath,
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 10),
                              Text(text,
                                  style: TextStyle(
                                      color: Color.fromRGBO(42, 0, 83, 1),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      },
                      itemCount: 2),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          clipBehavior: Clip.hardEdge,
                          child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "https://thanhnien.mediacdn.vn/Uploaded/camlt/2022_09_05/a6ffdac8853d72632b2c-kjuc-7459.jpeg")),
                        ))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Text(
                      "Tin tức nổi bật",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
                SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          border: Border.all(
                              width: 1.0,
                              style: BorderStyle.solid,
                              color: Color.fromRGBO(194, 194, 194, 0.8))),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.all(10)),
                          RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                text:
                                    "Hướng dẫn thủ tục khám chữ bệnh bảo hiểm y tế năm 2025 tại bệnh viện đại học thành phố hồ chí minh"),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          )
                        ],
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
