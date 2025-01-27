import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Footer extends StatelessWidget {
  final List<Map<String, String>> rows = [
    {
      "title": "Tin tức nổi bật",
      "icon": "image/newpaper.svg",
      "route": "/news"
    },
    {"title": "Hướng dẫn đặt lich", "icon": "image/question.svg", "route": "/promo"},
    {"title": "Hỗ trợ", "icon": "image/callhelp.svg", "route": "/guide"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.zero,
      child: ClipPath(
        clipper: WaveClipperTwo(flip: true, reverse: true),
        child: Container(
          height: 300,
          width: double.infinity,
          color: Colors.blueAccent,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 80),
            itemCount: rows.length,
            itemBuilder: (context, index) {
              final row = rows[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, row["route"]!);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              row["icon"]!,
                              width: 24,
                              height: 24,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            row["title"]!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_right, color: Colors.white),
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
