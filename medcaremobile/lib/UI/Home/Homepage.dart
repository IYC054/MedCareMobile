import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseProfile.dart';
import 'package:medcaremobile/UI/Appointment/ApptbySpecialty.dart';
import 'package:medcaremobile/UI/Home/Footer.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<StatefulWidget> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  Future<void> Showdialogappointment() async {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 700),
            tween: Tween<double>(begin: -30, end: 0),
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: Opacity(
                  opacity: (30 + value) / 30,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hàng đầu tiên
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            Apptbyspecialty(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1.0,
                        color: Color.fromRGBO(194, 194, 194, 0.8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "image/appointment.svg",
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Khám theo chuyên khoa",
                          style: TextStyle(
                            color: Color.fromRGBO(42, 0, 83, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ChooseProfile(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1.0,
                        color: Color.fromRGBO(194, 194, 194, 0.8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "image/doctor.svg",
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Khám với bác sĩ",
                          style: TextStyle(
                            color: Color.fromRGBO(42, 0, 83, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Hàng thứ hai

                SizedBox(height: 10), // Khoảng cách với nút X

                // Nút đóng (nằm dưới cùng)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(12),
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(220, 253, 255, 1),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          children: [
                            TextSpan(text: "Chào mừng bạn đến với "),
                            TextSpan(
                              text: "MedCare",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 50,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            String text = "";
                            // IconData icon = Icons.help;
                            String imagePath = "";

                            switch (index) {
                              case 0:
                                text = "Đặt Khám";
                                // icon = Icons.calendar_month;
                                imagePath = "image/appointment.svg";
                                break;
                              case 1:
                                text = "Lịch sử đặt khám";
                                // icon = Icons.accessible_sharp;
                                imagePath = "image/appointmentlist.svg";
                                break;
                              case 2:
                                text = "Hồ sơ sức khoẻ";
                                // icon = Icons.accessible_sharp;
                                imagePath = "image/patientclipboard.svg";
                                break;
                            }
                            return GestureDetector(
                                onTap: () {
                                  if (index == 0) {
                                    Showdialogappointment();
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                      color: Color.fromRGBO(194, 194, 194, 0.8),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        imagePath,
                                        width: 30,
                                        height: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        text,
                                        style: TextStyle(
                                          color: Color.fromRGBO(42, 0, 83, 1),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                          itemCount: 3,
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  "https://thanhnien.mediacdn.vn/Uploaded/camlt/2022_09_05/a6ffdac8853d72632b2c-kjuc-7459.jpeg",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Text(
                            "Tin tức nổi bật",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            border: Border.all(
                              width: 1.0,
                              style: BorderStyle.solid,
                              color: Color.fromRGBO(194, 194, 194, 0.8),
                            ),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.all(10)),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    text:
                                        "Hướng dẫn thủ tục khám chữa bệnh bảo hiểm y tế năm 2025 tại bệnh viện đại học thành phố Hồ Chí Minh"
                                            .toUpperCase(),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      "https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Footer()
              ],
            ),
          )),
        ],
      ),
    );
  }
}
