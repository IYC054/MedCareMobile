import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseInformation.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseDateScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseDoctorScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseSpecialtyScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseTimeScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';

class Choosedoctor extends StatefulWidget {
  const Choosedoctor({super.key, required this.profileId, required this.patientname});
  final int profileId;
  final String patientname;
  @override
  State<StatefulWidget> createState() => ChoosedoctorState();
}

class ChoosedoctorState extends State<Choosedoctor> {
  String? selectedDoctorName;
  int? selectedDoctorId;
  String? selectedSpecialtyName;
  int? selectedSpecialtyId;
  DateTime? selectDate;
  int? selectedWorkId;
  int? selectedWorkTimeId;
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
      MaterialPageRoute(
          builder: (context) => Choosespecialtyscreen(
                id: selectedDoctorId!,
              )),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectedSpecialtyId = result['specialtyid'];
        selectedSpecialtyName = result['specialty'];
      });
            print("selectedWorkTimeId $selectedSpecialtyId");

    }
  }

  void _selectDate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Choosedatescreen(
                id: selectedDoctorId!,
              )),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectDate = result['selectDate'];
        selectedWorkId = result['workId'];
      });
    }
  }

  void _selectTime() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChooseTimeScreen(
                id: selectedWorkId!,
              )),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectTime = result['selectTime'];
        selectedWorkTimeId = result['worktimeid'];
      });
    }
  }

  void _showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
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
                    onTap: selectedDoctorId != null
                        ? _selectSpecialty
                        : () => _showWarning("Vui lòng chọn bác sĩ trước!"),
                    enabled: selectedDoctorId !=
                        null, // Không nhấn được nếu chưa có bác sĩ
                  ),
                  _buildOptionCard(
                    icon: Icons.calendar_today,
                    title: selectDate != null
                        ? formatDate(selectDate!)
                        : 'Ngày khám',
                    onTap: selectedDoctorId != null
                        ? _selectDate
                        : () => _showWarning("Vui lòng chọn bác sĩ trước!"),
                    enabled: selectedDoctorId != null && selectedSpecialtyId != null,
                  ),
                  _buildOptionCard(
                    icon: Icons.access_time,
                    title: selectTime ?? 'Giờ khám',
                    onTap: selectedDoctorId != null
                        ? _selectTime
                        : () => _showWarning("Vui lòng chọn bác sĩ trước!"),
                    enabled: selectedDoctorId != null && selectedSpecialtyId != null && selectedWorkId != null,
                  ),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Chooseinformation(
                                  specialtyname: selectedSpecialtyName!,
                                  exminationdate: selectDate!,
                                  clinicdate: selectTime!,
                                  profileId: widget.profileId,
                                  patientName: widget.patientname,
                                  selectedDoctorId: selectedDoctorId,
                                  selectedSpecialtyId: selectedSpecialtyId,
                                  selectedWorkTimeId: selectedWorkTimeId,
                                  selectDate: selectDate,
                                  Doctorname: selectedDoctorName,
                                  selectTime: selectTime,
                                  selectedSpecialtyName: selectedSpecialtyName,
                                )));
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
    required VoidCallback? onTap, // Cho phép nhận null
    bool enabled = true, // Thêm trạng thái có thể nhấn hay không
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null, // Vô hiệu hóa nếu `enabled = false`
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: enabled
              ? Colors.white
              : Colors.grey.shade200, // Làm mờ nếu disabled
          border: Border.all(
            color: enabled ? Colors.grey.shade300 : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 24, color: enabled ? Colors.grey : Colors.grey.shade500),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: enabled
                      ? Colors.black
                      : Colors.grey.shade600, // Làm mờ text nếu disabled
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: enabled ? Colors.grey : Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}
