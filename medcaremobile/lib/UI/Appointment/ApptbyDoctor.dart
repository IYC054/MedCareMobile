import 'package:flutter/material.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';

class Apptbydoctor extends StatefulWidget {
  Apptbydoctor({super.key});

  @override
  State<StatefulWidget> createState() => ApptbydoctorState();
}

class ApptbydoctorState extends State<Apptbydoctor> {
  int page = 0;
  int counter = 4;
  List list = [0, 1, 2, 3];
  String titlechange = "Chọn hồ sơ";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      alignment: Alignment.center,
                      child: Text(
                        titlechange,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ))
                ],
              )),
          SizedBox(
            width: double.maxFinite,
            height: 30,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: FlutterStepIndicator(
                height: 28,
                paddingLine: const EdgeInsets.symmetric(horizontal: 0),
                positiveColor: const Color(0xFF00B551),
                progressColor: const Color(0xFFEA9C00),
                negativeColor: const Color(0xFFD5D5D5),
                padding: const EdgeInsets.all(4),
                list: list,
                division: counter,
                onChange: (i) {
                  if (i == 0) {
                    titlechange = "Chọn hồ sơ";
                  } else if (i == 1) {
                    titlechange = "Chọn chuyên khoa";
                  } else if (i == 2) {
                    titlechange = "Xác nhận thông tin";
                  } else if (i == 3) {
                    titlechange = "Thanh toán";
                  }
                },
                page: page,
                onClickItem: (p0) {
                  setState(() {
                    page = p0;
                  });
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Đảm bảo khoảng cách giữa 2 nút
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 5), // Padding bên phải của nút đầu tiên
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        // Xử lý khi nhấn nút Quay lại
                      },
                      child: Text(
                        "Quay lại",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 5), // Padding bên phải của nút đầu tiên
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        // Xử lý khi nhấn nút Quay lại
                      },
                      child: Text(
                        "Tiếp tục",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Widget widgetOption(
  //     {required String title,
  //     required VoidCallback callAdd,
  //     required VoidCallback callRemove}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
  //       decoration: BoxDecoration(
  //           color: Colors.blueGrey.withOpacity(0.03),
  //           borderRadius: BorderRadius.circular(15)),
  //       child: Column(
  //         children: [
  //           Container(
  //             width: double.maxFinite,
  //             height: 30,
  //             alignment: Alignment.center,
  //             child: Text(
  //               title,
  //               style: const TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               ElevatedButton(
  //                   onPressed: callAdd, child: const Icon(Icons.add)),
  //               ElevatedButton(
  //                   onPressed: callRemove, child: const Icon(Icons.remove)),
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
