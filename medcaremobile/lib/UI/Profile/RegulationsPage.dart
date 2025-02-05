import 'package:flutter/material.dart';

class RegulationsPage extends StatefulWidget {
  const RegulationsPage({super.key, required this.title});
  final String title;

  @override
  State<RegulationsPage> createState() => _RegulationsPageState();
}

class _RegulationsPageState extends State<RegulationsPage> {
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
              '1. Quy định chung',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Quy định này áp dụng cho tất cả bệnh nhân đăng ký khám bệnh thông qua hệ thống. '
              'Bệnh nhân cần tuân thủ các hướng dẫn và quy định của cơ sở y tế để đảm bảo quá trình khám chữa bệnh diễn ra thuận lợi.',
            ),
            SizedBox(height: 16),
            Text(
              '2. Thông tin bệnh nhân',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Bệnh nhân cần cung cấp đầy đủ và chính xác các thông tin cá nhân bao gồm: họ tên, ngày sinh, giới tính, địa chỉ và thông tin liên lạc. '
              'Thông tin sai lệch có thể ảnh hưởng đến quá trình khám chữa bệnh.',
            ),
            SizedBox(height: 16),
            Text(
              '3. Số chuyên khoa đăng ký',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Bệnh nhân có thể đăng ký khám tại một hoặc nhiều chuyên khoa tùy theo nhu cầu và tình trạng sức khỏe. '
              'Việc đăng ký nhiều chuyên khoa có thể dẫn đến thời gian chờ đợi lâu hơn.',
            ),
            SizedBox(height: 16),
            Text(
              '4. Thời gian đăng ký',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Thời gian đăng ký khám bệnh được mở từ 7h00 đến 17h00 các ngày trong tuần (trừ ngày lễ). '
              'Bệnh nhân nên đăng ký sớm để chọn được khung giờ phù hợp.',
            ),
            SizedBox(height: 16),
            Text(
              '5. Tiền và phí đăng ký khám',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Phí đăng ký khám bệnh sẽ được tính dựa trên từng chuyên khoa và dịch vụ mà bệnh nhân lựa chọn. '
              'Phí có thể thay đổi tùy thuộc vào quy định của cơ sở y tế.',
            ),
            SizedBox(height: 16),
            Text(
              '6. Phương thức thanh toán',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Bệnh nhân có thể thanh toán phí khám bệnh thông qua các phương thức sau:\n'
              '- Thanh toán trực tiếp tại quầy.\n'
              '- Chuyển khoản ngân hàng.\n'
              '- Thanh toán online qua cổng thanh toán điện tử.',
            ),
            SizedBox(height: 16),
            Text(
              '7. Cách thức nhận phiếu khám bệnh',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Sau khi hoàn tất đăng ký và thanh toán, bệnh nhân có thể nhận phiếu khám bệnh qua:\n'
              '- Email đăng ký.\n'
              '- Tin nhắn SMS.\n'
              '- Tải trực tiếp trên ứng dụng hoặc website.',
            ),
            SizedBox(height: 16),
            Text(
              '8. Giá trị sử dụng phiếu khám bệnh',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Phiếu khám bệnh chỉ có giá trị sử dụng cho lần đăng ký tương ứng và không thể chuyển nhượng cho người khác. '
              'Bệnh nhân cần xuất trình phiếu khám khi đến cơ sở y tế để được hỗ trợ nhanh chóng.',
            ),
          ],
        ),
      ),
    );
  }
}
