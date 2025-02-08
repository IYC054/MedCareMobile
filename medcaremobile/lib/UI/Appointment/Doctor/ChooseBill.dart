import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';

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
        title: const Text('Hoá đơn thanh toán'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressBar(currentStep: 5),
            const SizedBox(height: 24),
            Center(
              child: Icon(Icons.check_circle, color: Colors.green, size: 80),
            ),
            SizedBox(height: 20),
            Text(
              "Thanh toán thành công!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

            // Mã phiếu
            _buildInfoRow("Mã phiếu:", bookingId),

            // Tên bệnh nhân
            _buildInfoRow("Tên:", patientName),

            // Ngày giờ thanh toán
            _buildInfoRow("Ngày giờ:", paymentTime),

            // Tên bác sĩ
            _buildInfoRow("Tên bác sĩ:", doctorName),

            // Chuyên khoa
            _buildInfoRow("Chuyên khoa:", specialization),

            // Tổng tiền
            _buildInfoRow("Tổng tiền:", totalAmount, isHighlight: true),

            SizedBox(height: 30),

            // Button về trang chủ
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  "Về Trang Chủ",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
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
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
