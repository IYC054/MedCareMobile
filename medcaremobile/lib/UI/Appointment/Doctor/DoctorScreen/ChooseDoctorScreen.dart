import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';
import 'package:medcaremobile/services/GetDoctorApi.dart';

class ChooseDoctorScreen extends StatefulWidget {
  const ChooseDoctorScreen({Key? key, required this.isVIP, required this.specId}) : super(key: key);
  final bool isVIP;
  final int specId;
  @override
  _ChooseDoctorScreenState createState() => _ChooseDoctorScreenState();
}

class _ChooseDoctorScreenState extends State<ChooseDoctorScreen> {
  List<dynamic> doctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  void fetchDoctors() async {
    if (widget.isVIP) {
      final fetchedDoctors = await Getdoctorapi.fetchDoctorsbySpecialty(1);
      print(fetchedDoctors); // Kiểm tra dữ liệu từ API
      if (fetchedDoctors != null) {
        setState(() {
          doctors = fetchedDoctors;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      final fetchedDoctors = await Getdoctorapi.fetchDoctors();
      print(fetchedDoctors); // Kiểm tra dữ liệu từ API
      if (fetchedDoctors != null) {
        setState(() {
          doctors = fetchedDoctors;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

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
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator()) // Hiển thị loading
                  : ListView.builder(
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = doctors[index];
                        return _buildDoctorCard(
                          context,
                          id: doctor['id'] ?? 0, // Nếu null thì mặc định là 0
                          name: doctor['account']?['name'] ?? "Không có tên",
                          gender: doctor['gender'] == "Female" ? "Nữ" : "Nam",
                          specialty: (doctor['specialties'] != null &&
                                  doctor['specialties'].isNotEmpty)
                              ? doctor['specialties'][0]['name'] ??
                                  "Không có chuyên khoa"
                              : "Không có chuyên khoa",
                        );
                      },
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
