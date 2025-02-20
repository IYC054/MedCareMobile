import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseInformation.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseDateScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseDoctorScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseSpecialtyScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseTimeScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';
import 'package:medcaremobile/services/GetDoctorApi.dart';
import 'dart:math';

class Choosedoctor extends StatefulWidget {
  const Choosedoctor(
      {super.key, required this.profileId, required this.patientname});
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
  String? startTime;
  String? endTime;

  bool isVIP = false;

  // Thêm phương thức này để gán cho CustomCheckbox
  void _toggleVIP(bool value) {
    setState(() {
      isVIP = value;
      selectedDoctorName = null;
      selectedDoctorId = null;
      selectedSpecialtyName = null;
      selectedSpecialtyId = null;
      selectDate = null;
      selectedWorkId = null;
      selectedWorkTimeId = null;
      selectTime = null;
    });
    print("Khám VIP: $isVIP");
  }

  void _selectDoctor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChooseDoctorScreen(isVIP: false, specId: 0,)),
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
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectedSpecialtyId = result['specialtyid'];
        selectedSpecialtyName = result['specialty'];
      });
      print("selectedSpecialtyId $selectedSpecialtyId");
    }
    if (!isVIP) {
      _autoSelectDoctor(selectedSpecialtyId!);
    }
  }

  void _autoSelectDoctor(int specialtyId) async {
    final fetchedDoctors = await Getdoctorapi.fetchDoctors();
    print("Fetched Doctors: $fetchedDoctors"); // Debug xem API trả về gì

    if (fetchedDoctors.isEmpty) {
      print("Danh sách bác sĩ rỗng");
      return;
    }

    try {
      final filteredDoctors = fetchedDoctors.where((doctor) {
        if (doctor.containsKey('specialties') &&
            doctor['specialties'] is List) {
          return doctor['specialties']
              .any((specialty) => specialty['id'] == specialtyId);
        }
        return false;
      }).toList();

      print("filteredDoctors: $filteredDoctors");

      if (filteredDoctors.isNotEmpty) {
        final randomDoctor =
            filteredDoctors[Random().nextInt(filteredDoctors.length)];
        print("randomDoctor: ${randomDoctor['account']['name']}");

        setState(() {
          selectedDoctorId = randomDoctor['id'];
          selectedDoctorName = randomDoctor['account']['name'];
        });

        return;
      } else {
        print("Không có bác sĩ nào với specialtyId này.");
      }
    } catch (e) {
      print("Lỗi khi lọc bác sĩ: $e");
    }
  }

  void _selectDate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Choosedatescreen(
                id: selectedDoctorId!,
                doctoId: selectedDoctorId,
                isVIP: isVIP,
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
                selectedDate: selectDate!,
                isVIP: isVIP,
                id: selectedWorkId!,
              )),
    );

    print("📢 Dữ liệu nhận được từ ChooseTimeScreen: $result"); // Debug

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectTime = result['selectTime'];
        selectedWorkTimeId = result['worktimeid'];
        startTime = result['startTime'];
        endTime = result['endTime'];
      });

      print("✅ Gán thành công: $startTime - $endTime"); // Debug
    } else {
      print("⚠️ Không nhận được dữ liệu hợp lệ!"); // Debug
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
                  if (isVIP)
                    _buildOptionCard(
                      icon: Icons.person,
                      title: selectedDoctorName ?? 'Bác sĩ',
                      onTap: _selectDoctor,
                    ),
                  _buildOptionCard(
                    icon: Icons.health_and_safety_outlined,
                    title: selectedSpecialtyName ?? 'Chuyên khoa',
                    onTap: isVIP && selectedDoctorId == null
                        ? null
                        : _selectSpecialty, // Nếu VIP mà chưa chọn bác sĩ -> Không cho chọn chuyên khoa
                    enabled: isVIP
                        ? selectedDoctorId != null
                        : true, // Nếu VIP thì phải chọn bác sĩ trước
                  ),
                  _buildOptionCard(
                    icon: Icons.calendar_today,
                    title: selectDate != null
                        ? formatDate(selectDate!)
                        : 'Ngày khám',
                    onTap: _selectDate,
                    enabled: isVIP
                        ? selectedDoctorId != null
                        : selectedSpecialtyId != null,
                  ),
                  _buildOptionCard(
                    icon: Icons.access_time,
                    title: selectTime ?? 'Giờ khám',
                    onTap: _selectTime,
                    enabled:
                        isVIP ? selectDate != null : selectedWorkId != null,
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
                                  isVIP: isVIP,
                                  startTime: startTime,
                                  endTime: endTime,
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

class CustomCheckbox extends StatefulWidget {
  @override
  const CustomCheckbox({super.key, required this.onChanged});
  final ValueChanged<bool> onChanged;

  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isChecked = !isChecked;
          });
          widget.onChanged(isChecked); // Sử dụng giá trị đã cập nhật
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: isHovered ? Colors.blue : Colors.grey, width: 2),
            color: isChecked ? Colors.blue : Colors.white,
          ),
          child: isChecked
              ? Icon(Icons.check, color: Colors.white, size: 24)
              : null,
        ),
      ),
    );
  }
}
