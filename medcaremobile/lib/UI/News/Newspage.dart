import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/UI/News/NewDetailpage.dart';
import 'dart:convert';
import 'package:medcaremobile/services/IpNetwork.dart';
import 'Newspage.dart'; // Import trang chi tiết

class NewspagePage extends StatefulWidget {
  const NewspagePage({super.key});

  @override
  State<NewspagePage> createState() => _NewspagePageState();
}

class _NewspagePageState extends State<NewspagePage> {
  List<dynamic> newsList = [];
  bool isLoading = true;
  static const ip = Ipnetwork.ip;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final response = await http
          .get(
            Uri.parse('http://$ip:8080/api/news'),
            headers: {"Accept": "application/json"},
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        setState(() {
          newsList = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('❌ Error fetching news: $e');
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
                  padding: EdgeInsets.all(10),
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    final news = newsList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewDetailpage(
                              title: news['title'] ?? 'Không có tiêu đề',
                              description: news['description'] ?? 'Không có nội dung',
                              date: news['date'] ?? 'Không rõ ngày',
                              imageUrl: news['images'] ?? '',
                            ),
                          ),
                        );
                      },
                      child: _buildNotificationItem(
                        news['title'] ?? 'Không có tiêu đề',
                        news['description'] ?? 'Không có nội dung',
                        news['date'] ?? 'Không rõ ngày',
                        news['images'] ?? '',
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildNotificationItem(
      String title, String description, String date, String imageUrl) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    date,
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
