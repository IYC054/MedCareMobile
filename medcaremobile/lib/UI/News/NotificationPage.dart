import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<dynamic> newsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
     final response = await http.get(Uri.parse('http://192.168.1.17:8080/api/news'));
      if (response.statusCode == 200) {
        setState(() {
          newsList = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error fetching news: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Danh sách thông báo'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : newsList.isEmpty
              ? Center(child: Text('Không có thông báo'))
              : ListView.builder(
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    final news = newsList[index];
                    return _buildNotificationItem(
                      news['title'] ?? 'Không có tiêu đề',
                      news['description'] ?? 'Không có nội dung',
                      news['date'] ?? 'Không rõ ngày',
                    );
                  },
                ),
    );
  }

  Widget _buildNotificationItem(String title, String description, String date) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.notifications, color: Colors.white),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description),
          SizedBox(height: 4),
          Text(date, style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
