import 'package:flutter/material.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({super.key, required this.title});
  final String title;

  @override
  State<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              '1. Giới thiệu về MedPro',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'MedPro là nền tảng chăm sóc sức khỏe thông minh, giúp người dùng dễ dàng đặt lịch khám bệnh, quản lý hồ sơ y tế và tiếp cận các dịch vụ y tế chất lượng cao từ các bệnh viện và phòng khám hàng đầu.',
            ),
            SizedBox(height: 16),
            Text(
              '2. Khi nào chúng tôi sẽ thu thập dữ liệu cá nhân?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Chúng tôi thu thập dữ liệu cá nhân của bạn khi:\n'
              '- Đăng ký tài khoản trên ứng dụng MedPro.\n'
              '- Đặt lịch hẹn khám bệnh hoặc sử dụng các dịch vụ y tế.\n'
              '- Tham gia khảo sát, phản hồi hoặc chương trình khuyến mãi.\n'
              '- Liên hệ với đội ngũ hỗ trợ khách hàng của chúng tôi.',
            ),
            SizedBox(height: 16),
            Text(
              '3. Chúng tôi sẽ thu thập những dữ liệu gì?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Các dữ liệu cá nhân mà MedPro thu thập bao gồm:\n'
              '- Thông tin cá nhân: họ tên, ngày sinh, giới tính, địa chỉ.\n'
              '- Thông tin liên hệ: số điện thoại, email.\n'
              '- Thông tin y tế: lịch sử khám bệnh, đơn thuốc, chẩn đoán.\n'
              '- Dữ liệu kỹ thuật: địa chỉ IP, loại thiết bị, hệ điều hành.',
            ),
            SizedBox(height: 16),
            Text(
              '4. Cài đặt tài khoản',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Để sử dụng đầy đủ các tính năng của MedPro, bạn cần:\n'
              '- Tạo tài khoản bằng cách cung cấp thông tin cơ bản.\n'
              '- Xác minh danh tính thông qua email hoặc số điện thoại.\n'
              '- Đặt mật khẩu mạnh để bảo vệ tài khoản của bạn.',
            ),
            SizedBox(height: 16),
            Text(
              '5. Truy cập phần mềm',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Bạn có thể truy cập MedPro thông qua:\n'
              '- Ứng dụng di động trên iOS và Android.\n'
              '- Trình duyệt web trên máy tính hoặc thiết bị di động.\n\n'
              'Để đảm bảo bảo mật, hãy luôn đăng xuất sau khi sử dụng và không chia sẻ thông tin tài khoản với người khác.',
            ),
          ],
        ),
      ),
    );
  }
}
