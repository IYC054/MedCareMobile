import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';

class ChoosePaymentScreen extends StatefulWidget {
  const ChoosePaymentScreen({super.key});

  @override
  State<ChoosePaymentScreen> createState() => _ChoosePaymentScreenState();
}

class _ChoosePaymentScreenState extends State<ChoosePaymentScreen> {
  String selectedPayment = ''; // Phương thức mặc định

  void selectPayment(String payment) {
    setState(() {
      selectedPayment = payment;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn thông tin khám'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressBar(currentStep: 4),
            const SizedBox(height: 24),
            Text(
              'Vui lòng kiểm tra thông tin đăng ký và chọn phương thức thanh toán.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Sau khi thanh toán thành công, bạn vui lòng đợi nhận PHIẾU KHÁM BỆNH, không đóng ứng dụng.',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            Divider(height: 32),
            Text(
              'Chuyên khoa đã chọn (1)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.health_and_safety, color: Colors.red),
              title: Text('PHẪU THUẬT HÀM MẶT - RHM'),
              trailing: Text('150.000đ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Divider(height: 32),
            Text(
              'Phương thức thanh toán',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            PaymentOption(
              title: 'Ví điện tử MoMo',
              icon: Icons.account_balance_wallet,
              selected: selectedPayment == 'Ví điện tử MoMo',
              onTap: () => selectPayment('Ví điện tử MoMo'),
            ),
            PaymentOption(
              title: 'Ứng dụng Mobile Banking',
              icon: Icons.mobile_friendly,
              selected: selectedPayment == 'Ứng dụng Mobile Banking',
              onTap: () => selectPayment('Ứng dụng Mobile Banking'),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '150.000đ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text('Quay lại'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    
                  },
                  child: Text('Tiếp tục'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


}

class PaymentOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const PaymentOption({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(icon, color: selected ? Colors.green : Colors.grey),
          title: Text(title),
          trailing: selected
              ? Icon(Icons.check_circle, color: Colors.green)
              : Icon(Icons.circle_outlined, color: Colors.grey),
        ),
        Divider(),
      ],
    );
  }
}
