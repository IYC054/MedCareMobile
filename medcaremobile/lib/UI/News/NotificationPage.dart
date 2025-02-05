import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: Text('Danh sách thông báo'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTab('Phiếu khám (0)', false),
                _buildTab('Tin tức (59)', true),
                _buildTab('Thông báo', false),
              ],
            ),
          ),
          Divider(),
          _buildSectionTitle('Hôm nay'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Không có thông báo mới',
                style: TextStyle(color: Colors.black54)),
          ),
          _buildSectionTitle('Trước đó'),
          Expanded(
            child: ListView(
              children: [
                _buildNotificationItem(
                    '👨‍⚕️ Danh sách bác sĩ trực Tết',
                    'Tết an tâm, sức khỏe tốt! Xem ngay danh sách bác sĩ trực Tết và gọi video tư vấn khi cần trên Medpro.',
                    '4 ngày trước'),
                _buildNotificationItem(
                    '⚡ Danh sách bệnh viện trực Tết',
                    'Dễ dàng tra cứu các bệnh viện hoạt động xuyên Tết để kịp thời chăm sóc sức khỏe.',
                    '4 ngày trước'),
                _buildNotificationItem(
                    '🎉 Chào năm mới 2025!',
                    'Medpro kính chúc quý khách một năm mới sức khỏe dồi dào, vạn sự như ý.',
                    '5 ngày trước'),
                _buildNotificationItem(
                    '🔥 Lịch nghỉ tết các bệnh viện',
                    'Medpro xin thông báo lịch nghỉ Tết Nguyên đán 2025 và các bệnh viện trực Tết.',
                    '6 ngày trước'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String description, String date) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.email, color: Colors.white),
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
