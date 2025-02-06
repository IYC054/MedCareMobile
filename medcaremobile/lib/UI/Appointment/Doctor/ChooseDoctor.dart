import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseInformation.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseDateScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseDoctorScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseSpecialtyScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseTimeScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';

class Choosedoctor extends StatefulWidget {
  const Choosedoctor({super.key});

  @override
  State<StatefulWidget> createState() => ChoosedoctorState();
}

class ChoosedoctorState extends State<Choosedoctor> {
  String? selectedDoctorName;
  int? selectedDoctorId;
  String? selectedSpecialtyName;
  int? selectedSpecialtyId;
  DateTime? selectDate;
  String? selectTime;
  void _selectDoctor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChooseDoctorScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectedDoctorId = result['id'];
        selectedDoctorName = result['name'];
      });
    }
  }

  void _selectSpecialty() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Choosespecialtyscreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectedSpecialtyId = result['specialtyid'];
        selectedSpecialtyName = result['specialty'];
      });
    }
  }

  void _selectDate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Choosedatescreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectDate = result['selectDate'];
      });
    }
  }

  void _selectTime() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChooseTimeScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectTime = result['selectTime'];
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
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
            // Progress bar
            ProgressBar(currentStep: 2),
            const SizedBox(height: 24),
            // Title
            const Text(
              'Chọn thông tin khám',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Options
            Expanded(
              child: ListView(
                children: [
                  _buildOptionCard(
                    icon: Icons.person,
                    title: selectedDoctorName ?? 'Bác sĩ',
                    onTap: _selectDoctor,
                  ),
                  _buildOptionCard(
                      icon: Icons.health_and_safety_outlined,
                      title: selectedSpecialtyName ?? 'Chuyên khoa',
                      onTap: _selectSpecialty),
                  _buildOptionCard(
                    icon: Icons.calendar_today,
                    title: selectDate != null
                        ? formatDate(selectDate!)
                        : 'Ngày khám',
                    onTap: _selectDate,
                  ),
                  _buildOptionCard(
                      icon: Icons.access_time,
                      title: selectTime ?? 'Giờ khám',
                      onTap: _selectTime),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Next button
            if (selectDate != null &&
                selectTime != null &&
                selectedDoctorName != null &&
                selectedSpecialtyName != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the next step
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Chooseinformation()));
                  },
                  child: const Text('Tiếp theo'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
