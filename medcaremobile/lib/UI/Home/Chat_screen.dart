import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  // Gửi tin nhắn và hiển thị trên giao diện
  void _sendMessage(String text, bool isUser) {
    if (text.isNotEmpty) {
      setState(() {
        messages.add({'text': text, 'isUser': isUser});
      });
      _controller.clear();

      if (!isUser) {
        _callApi(text); // Gọi API khi gửi tin nhắn từ bot
      }
    }
  }

  // Gọi API lấy phản hồi
  Future<void> _callApi(String userMessage) async {
    final url = Uri.parse("https://api.example.com/chat"); 
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"message": userMessage}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        messages.add({'text': data["reply"], 'isUser': false});
      });
    } else {
      setState(() {
        messages.add({'text': "Lỗi kết nối API!", 'isUser': false});
      });
    }
  }

  // Danh sách lựa chọn
  final List<String> options = [
    "Tư vấn sức khỏe",
    "Đặt lịch khám",
    "Hỗ trợ khẩn cấp"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 33, 33, 0.6),
      appBar: AppBar(
  backgroundColor: Colors.blue,
  title: Row(
    children: [
      Image.asset(
        'image/chatbot.png', // Đường dẫn đến ảnh
        height: 30, // Điều chỉnh kích thước ảnh
      ),
      SizedBox(width: 10), // Tạo khoảng cách giữa ảnh và text
      Text(
        "Trợ lý ảo MedCare",
        style: TextStyle(color: Colors.white),
      ),
    ],
  ),
),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  clipper: ChatBubbleClipper5(
                      type: messages[index]['isUser']
                          ? BubbleType.sendBubble
                          : BubbleType.receiverBubble),
                  alignment: messages[index]['isUser']
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  margin: EdgeInsets.only(top: 10),
                  backGroundColor: messages[index]['isUser']
                      ? Colors.pinkAccent
                      : Colors.grey[300],
                  child: Text(
                    messages[index]['text'],
                    style: TextStyle(
                        color: messages[index]['isUser']
                            ? Colors.white
                            : Colors.black),
                  ),
                );
              },
            ),
          ),
          _buildOptions(), 
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Widget tạo 3 lựa chọn
  Widget _buildOptions() {
    return Container(
      width: double.infinity,
      color: Colors.white.withOpacity(0.1),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  _sendMessage(option, true);
                  _callApi(option);
                },
                child: Text(option, style: TextStyle(color: Colors.white),),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Widget nhập tin nhắn
  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Color.fromRGBO(38, 50, 56, 0.8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Nhập nội dung...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () => _sendMessage(_controller.text, true),
          ),
        ],
      ),
    );
  }
}
