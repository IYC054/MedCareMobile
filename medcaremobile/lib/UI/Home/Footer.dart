import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Footer extends StatelessWidget {
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
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 80, left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              "image/newpaper.svg",
                              width: 24,
                              height: 24,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Tin tức nổi bật",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_right, color: Colors.white),
                        ],
                      ),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.white,
                        margin: EdgeInsets.only(top: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
