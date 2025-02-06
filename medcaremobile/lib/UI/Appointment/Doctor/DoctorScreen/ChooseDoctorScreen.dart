import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';

class ChooseDoctorScreen extends StatelessWidget {
  const ChooseDoctorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn bác sĩ'),
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
          children: [
            ProgressBar(currentStep: 2),
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bác sĩ...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildDoctorCard(
                    context,
                    name: 'TS BS. Phan Huỳnh An',
                    id: 1,
                    gender: 'Nam',
                    specialty: 'Phẫu thuật hàm mặt - RHM',
                    schedule: 'Sáng thứ 4',
                    price: '150.000đ',
                  ),
                  _buildDoctorCard(
                    context,
                    name: 'ThS BS. Lê Thụy Minh An',
                    id: 2,
                    gender: 'Nữ',
                    specialty: 'Thần kinh',
                    schedule: 'Chiều thứ 5',
                    price: '150.000đ',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(
    BuildContext context, {
    required String name,
    required int id,
    required String gender,
    required String specialty,
    required String schedule,
    required String price,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 4),
            Text('Giới tính: $gender'),
            Text('Chuyên khoa: $specialty'),
            Text('Buổi khám: $schedule', style: TextStyle(color: Colors.green)),
            Text('Giá khám: $price',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {'id': id, 'name': name});
                },
                child: Text('Chọn'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
