import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Profile/PersonalProfile.dart';
import 'package:medcaremobile/UI/Profile/PrivacyPolicyPage.dart';
import 'package:medcaremobile/UI/Profile/ProfilePage.dart';
import 'package:medcaremobile/UI/Profile/RegulationsPage.dart';
import 'package:medcaremobile/UI/Profile/TermsOfServicePage.dart';

import 'package:medcaremobile/UI/Profile/FAQPage.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.grey),
          ),
          const Text(
            "nguyễn anh tuấn",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
           const Text(
            "079*****04",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                children: [
                  const Text(
                    "Điều khoản sử dụng",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildListTile(
                      Icons.verified_user, "Quy định sử dụng", context),
                  buildListTile(Icons.lock, "Chính sách bảo mật", context),
                  buildListTile(
                      Icons.description, "Điều khoản dịch vụ", context),
                  Divider(
                      color: const Color.fromARGB(255, 209, 209, 209),
                      thickness: 3),
                  buildListTile(
                      Icons.person_outlined, "Thông tin cá nhân", context),
                  Divider(
                      color: const Color.fromARGB(255, 209, 209, 209),
                      thickness: 3),
                  buildListTile(Icons.phone, "Tổng đài CSKH 19002115", context),
                  Divider(
                      color: const Color.fromARGB(255, 209, 209, 209),
                      thickness: 3),
                  buildListTile(Icons.thumb_up, "Đánh giá ứng dụng", context),
                  buildListTile(Icons.share, "Chia sẻ ứng dụng", context),
                  Divider(
                      color: const Color.fromARGB(255, 209, 209, 209),
                      thickness: 3),
                  buildListTile(
                      Icons.help, "Một số câu hỏi thường gặp", context),
                  buildListTile(Icons.logout_outlined, "Đăng xuất", context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile buildListTile(IconData icon, String title, BuildContext context) {
    Color iconColor = Colors.blue; // Mặc định là màu blue

    if (title == "Quy định sử dụng") {
      iconColor = Colors.green;
    } else if (title == "Chính sách bảo mật") {
      iconColor = Colors.orange;
    } else if (title == "Điều khoản dịch vụ") {
      iconColor = Colors.red;
    } else if (title == "Thông tin cá nhân") {
      iconColor = Colors.purple;
    } else if (title == "Tổng đài CSKH 19002115") {
      iconColor = Colors.teal;
    } else if (title == "Đánh giá ứng dụng") {
      iconColor = Colors.amber;
    } else if (title == "Chia sẻ ứng dụng") {
      iconColor = Colors.indigo;
    } else if (title == "Một số câu hỏi thường gặp") {
      iconColor = Colors.brown;
    } else if (title == "Đăng xuất") {
      iconColor = Colors.redAccent;
    }
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor, 
      ),
      title: Text(title),
      trailing: (title != "Tổng đài CSKH 19002115" &&
              title != "Đánh giá ứng dụng" &&
              title != "Chia sẻ ứng dụng")
          ? const Icon(Icons.arrow_forward_ios, size: 16)
          : null,
      onTap: () async {
        if (title == "Quy định sử dụng") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RegulationsPage(
                      title: "Quy định sử dụng",
                    )),
          );
        } else if (title == "Chính sách bảo mật") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PrivacyPolicyPage(
                      title: "Chính sách bảo mật",
                    )),
          );
        } else if (title == "Điều khoản dịch vụ") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TermsOfServicePage(
                      title: "Điều khoản dịch vụ",
                    )),
          );
        } else if (title == "Một số câu hỏi thường gặp") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const FAQPage(
                      title: "Một số câu hỏi thường gặp",
                    )),
          );
        } else if (title == "Thông tin cá nhân") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PersonalProfile(
                      title: "Thông tin cá nhân",
                    )),
          );
        }
      },
    );
  }
}
