import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key, required this.title});
  final String title;

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
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
              '1. Giới thiệu',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Chào mừng bạn đến với ứng dụng MedPro. Chúng tôi cam kết bảo vệ quyền riêng tư và dữ liệu cá nhân của bạn. Chính sách này sẽ giúp bạn hiểu rõ về cách chúng tôi thu thập, sử dụng và bảo vệ thông tin của bạn.',
            ),
            SizedBox(height: 16),
            Text(
              '2. Bảo mật',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Chúng tôi áp dụng các biện pháp bảo mật nghiêm ngặt để bảo vệ dữ liệu cá nhân của bạn khỏi truy cập trái phép, thay đổi hoặc tiết lộ không mong muốn. Các biện pháp bao gồm:\n'
              '- Mã hóa dữ liệu.\n'
              '- Xác thực hai yếu tố.\n'
              '- Kiểm soát truy cập nghiêm ngặt đối với hệ thống nội bộ.',
            ),
            SizedBox(height: 16),
            Text(
              '3. Giới hạn về quyền sử dụng',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Người dùng không được:\n'
              '- Sử dụng ứng dụng cho các mục đích bất hợp pháp hoặc gây hại.\n'
              '- Sao chép, phân phối hoặc chỉnh sửa phần mềm mà không có sự cho phép.\n'
              '- Thu thập dữ liệu từ ứng dụng mà không có sự đồng ý rõ ràng của chúng tôi.',
            ),
            SizedBox(height: 16),
            Text(
              '4. Phần mềm',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Ứng dụng MedPro được phát triển để cung cấp dịch vụ đặt lịch khám bệnh, quản lý hồ sơ y tế và các tính năng liên quan. Chúng tôi có quyền cập nhật, thay đổi hoặc ngừng cung cấp ứng dụng mà không cần thông báo trước.',
            ),
            SizedBox(height: 16),
            Text(
              '5. Tài khoản bảo mật',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Bạn chịu trách nhiệm bảo mật thông tin tài khoản của mình. Vui lòng:\n'
              '- Không chia sẻ mật khẩu với người khác.\n'
              '- Đổi mật khẩu định kỳ để tăng cường bảo mật.\n'
              '- Thông báo ngay cho chúng tôi nếu phát hiện hoạt động đáng ngờ liên quan đến tài khoản của bạn.',
            ),
          ],
        ),
      ),
    );
  }
}
