import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Profile/HistoryPage.dart';
import 'package:medcaremobile/UI/Profile/PatientFilePage.dart';
import 'package:medcaremobile/UI/Profile/PersonalProfile.dart';
import 'package:medcaremobile/UI/Profile/PrivacyPolicyPage.dart';
import 'package:medcaremobile/UI/Profile/ProfilePage.dart';
import 'package:medcaremobile/UI/Profile/RegulationsPage.dart';
import 'package:medcaremobile/UI/Profile/TermsOfServicePage.dart';

import 'package:medcaremobile/UI/Profile/FAQPage.dart';
import 'package:medcaremobile/services/StorageService.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../Home/Home.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  Map<String, dynamic>? userdata;
  bool isLoading = true;
  //xu ly logout
  Future<void> _loadUserData() async {
    final user = await StorageService.getUser();
    if (user != null) {
      setState(() {
        userdata = user;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

  void _logout(BuildContext context) {
    StorageService.clearToken();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đăng xuất thành công!")),
    );

    // Điều hướng về màn hình chính
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  void _callCustomerService() async {
    const phoneNumber = "tel:19002115";
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
    } else {
      debugPrint("Không thể mở trình quay số.");
    }
  }

  void _shareApp() {
    Share.share(
        "Hãy thử ngay ứng dụng này: https://play.google.com/store/apps/details?id=vn.com.medpro");
  }

  void _openAppReview() async {
    const url =
        "https://play.google.com/store/apps/details?id=vn.com.medpro"; // Thay bằng link ứng dụng của bạn
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Không thể mở trang đánh giá.");
    }
  }

  //show diaglog confirm logout
  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Người dùng phải chọn Yes/No
      builder: (BuildContext context) {
        return AlertDialog(
          icon: Icon(
            Icons.logout_outlined,
            color: Colors.red,
          ),
          title: Text(
            'Xác nhận đăng xuất',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng Dialog
              },
            ),
            TextButton(
              child: Text('Đăng xuất', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng Dialog
                _logout(context); // Gọi hàm xử lý đăng xuất
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(userdata?["name"]);
    print(userdata?["phone"]);
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
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Hiển thị loading khi đang tải dữ liệu
            )
          : Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.grey),
                ),
                Text(
                  userdata?["name"],
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  userdata?["phone"],
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: ListView(
                      children: [
                        const Text(
                          "Điều khoản và quy định",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        buildListTile(
                            Icons.verified_user, "Quy định sử dụng", context),
                        buildListTile(
                            Icons.lock, "Chính sách bảo mật", context),
                        buildListTile(
                            Icons.description, "Điều khoản dịch vụ", context),
                        Divider(
                            color: const Color.fromARGB(255, 209, 209, 209),
                            thickness: 3),
                        buildListTile(Icons.person_outlined,
                            "Thông tin cá nhân", context),
                        buildListTile(
                            Icons.personal_injury, "Lịch khám", context),
                        buildListTile(
                            Icons.payment, "Lịch sử thanh toán", context),
                        Divider(
                            color: const Color.fromARGB(255, 209, 209, 209),
                            thickness: 3),
                        buildListTile(
                            Icons.phone, "Tổng đài CSKH 19002115", context),
                        Divider(
                            color: const Color.fromARGB(255, 209, 209, 209),
                            thickness: 3),
                        buildListTile(
                            Icons.thumb_up, "Đánh giá ứng dụng", context),
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
    Color iconColor = Colors.blue; // Mặc định là màu blue

    if (title == "Quy định sử dụng") {
      iconColor = Colors.green;
    } else if (title == "Lịch sử thanh toán") {
      iconColor = Colors.green;
    } else if (title == "Lịch khám") {
      iconColor = Colors.red;
    } else if (title == "Chính sách bảo mật") {
      iconColor = Colors.orange;
    } else if (title == "Điều khoản dịch vụ") {
      iconColor = Colors.indigoAccent;
    } else if (title == "Thông tin cá nhân") {
      iconColor = Colors.purple;
    } else if (title == "Tổng đài CSKH 19002115") {
      iconColor = Colors.grey;
    } else if (title == "Đánh giá ứng dụng") {
      iconColor = Colors.amber;
    } else if (title == "Một số câu hỏi thường gặp") {
      iconColor = Colors.black;
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
        if (title == "Tổng đài CSKH 19002115") {
          _callCustomerService();
        } else if (title == "Đánh giá ứng dụng") {
          _openAppReview();
        } else if (title == "Chia sẻ ứng dụng") {
          _shareApp();
        } else if (title == "Quy định sử dụng") {
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
        } else if (title == "Lịch khám") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PatientFilePage(
                      title: "Lịch khám",
                    )),
          );
        } else if (title == "Lịch sử thanh toán") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HistoryPage(
                      title: "Lịch sử thanh toán",
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
        } else if (title == "Đăng xuất") {
          _showLogoutDialog(context); // Gọi dialog xác nhận
        }
      },
    );
  }
}
