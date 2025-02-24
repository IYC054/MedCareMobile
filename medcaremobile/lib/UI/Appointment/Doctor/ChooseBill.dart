import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';
import 'package:medcaremobile/UI/Home/Home.dart';

class Choosebill extends StatelessWidget {
  final String bookingId;
  final String patientName;
  final String paymentTime;
  final String doctorName;
  final String specialization;
  final String totalAmount;

  Choosebill({
    required this.bookingId,
    required this.patientName,
    required this.paymentTime,
    required this.doctorName,
    required this.specialization,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hóa đơn thanh toán', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue[600],
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProgressBar(currentStep: 5),
            const SizedBox(height: 24),

            // Icon xác nhận thành công
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 1),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Icon(Icons.check_circle, color: Colors.green, size: 100),
            ),

            const SizedBox(height: 16),

            Text(
              "Đặt lịch thành công!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[700]),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // Hộp chứa thông tin hóa đơn
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInfoRow("Mã phiếu:", bookingId),
                    _buildInfoRow("Tên bệnh nhân:", patientName),
                    _buildInfoRow("Ngày giờ:", paymentTime),
                    _buildInfoRow("Bác sĩ:", doctorName),
                    _buildInfoRow("Chuyên khoa:", specialization),
                    Divider(thickness: 1.2, color: Colors.grey[300]),
                    _buildInfoRow("Tổng tiền:", totalAmount, isHighlight: true),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Nút quay về trang chủ
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                elevation: 5,
              ),
              child: Text(
                "Về Trang Chủ",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tạo hàng thông tin
  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? Colors.redAccent : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
