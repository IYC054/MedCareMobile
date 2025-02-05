import 'package:flutter/material.dart';
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
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text("Đăng xuất"),
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
                  buildListTile(
                      Icons.logout_outlined, "Đăng xuất", context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile buildListTile(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
        }
      },
    );
  }
}
