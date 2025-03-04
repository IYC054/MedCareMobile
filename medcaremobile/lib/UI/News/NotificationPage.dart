import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/FirestoreService.dart';
import 'package:medcaremobile/services/IpNetwork.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifications = [];
  static const ip = Ipnetwork.ip;
  String url = "http://$ip:8080/api/news/noti";
  bool isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    getUserAndFetchNotifications();
  }

  Future<void> getUserAndFetchNotifications() async {
    // Lấy ID của người dùng hiện tại từ Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
        print("userId: $userId");
      });
      fetchNotifications(userId!);
    } else {
      print("Người dùng chưa đăng nhập!");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchNotifications(String userId) async {
    if (userId == null) {
      getUserAndFetchNotifications();
      return;
    }
    try {
      final response = await http.get(Uri.parse("$url/$userId"));

      print("Fetching from: $url/$userId");
      if (response.statusCode == 200) {
        // Giải mã UTF-8 để tránh lỗi font
        final utf8Decoded = utf8.decode(response.bodyBytes);
        final List<dynamic> responseData = jsonDecode(utf8Decoded);

        setState(() {
          notifications =
              responseData.map((e) => Map<String, dynamic>.from(e)).toList();
          isLoading = false;
        });
      } else {
        print("Lỗi khi gọi API: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Lỗi kết nối API: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        automaticallyImplyLeading: false,
        title: Text('Danh sách thông báo', style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if (userId != null) fetchNotifications(userId!);
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(child: Text('Không có thông báo'))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final noti = notifications[index];
                    return _buildNotificationItem(
                        noti['id'] ?? "", // ID của thông báo
                        noti['body'] ?? 'Không có nội dung',
                        noti['title'] ?? 'Không có tiêu đề',
                        noti['status'] ?? 'unread');
                  },
                ),
    );
  }

  Widget _buildNotificationItem(
      String notificationId, String title, String body, String status) {
    bool isRead = status == "read";

    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            isRead ? Colors.blue : Colors.red, // Đổi màu nếu đã đọc
        child: Icon(Icons.notifications, color: Colors.white),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isRead ? FontWeight.normal : FontWeight.bold, // chưa đọc
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(body),
          SizedBox(height: 7),
        ],
      ),
      onTap: () {
        if (!isRead) {
          FirestoreService.markNotificationAsRead(
              notificationId); // Đánh dấu đã đọc
          setState(() {
            getUserAndFetchNotifications();
          });
        }
      },
    );
  }
}
