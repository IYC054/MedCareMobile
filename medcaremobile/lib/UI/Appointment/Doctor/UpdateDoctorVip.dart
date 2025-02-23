import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseInformation.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseDateScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseDoctorScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseSpecialtyScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/DoctorScreen/ChooseTimeScreen.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';
import 'package:medcaremobile/UI/Profile/PatientFilePage.dart';
import 'package:medcaremobile/services/GetAppointmentApi.dart';
import 'package:medcaremobile/services/GetDoctorApi.dart';
import 'dart:math';

class Updatedoctorvip extends StatefulWidget {
  const Updatedoctorvip({super.key, required this.appointmentVIPID});
  final int appointmentVIPID;
  @override
  State<StatefulWidget> createState() => UpdatedoctorvipState();
}

class UpdatedoctorvipState extends State<Updatedoctorvip> {
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
  bool? isVIP = true;
  int? profileId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchVipAppointmentbyId();
  }

  void fetchVipAppointmentbyId() async {
    Map<String, dynamic>? result =
        await GetAppointmentApi.GetVipAppointmentbyId(widget.appointmentVIPID);
    if (result != null) {
      print("Lịch VIP: $result");

      setState(() {
        selectedDoctorName = result['doctor']['account']['name'];
        selectedDoctorId = result['doctor']['id'];
        selectedSpecialtyName = result['type'];
        selectDate = DateTime.parse(result['workDate']);
        startTime = result['startTime'];
        endTime = result['endTime'];
        selectTime = "${result['startTime']} - ${result['endTime']}";
      });
    } else {
      print("Không tìm thấy lịch hẹn VIP");
    }
  }

  // Thêm phương thức này để gán cho CustomCheckbox

  void _selectDoctor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChooseDoctorScreen(
                isVIP: true,
                specId: selectedSpecialtyId!,
              )),
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
        builder: (context) => Choosespecialtyscreen(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectedSpecialtyId = result['specialtyid'];
        selectedSpecialtyName = result['specialty'];
      });
      print("selectedSpecialtyId $selectedSpecialtyId");
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
        selectTime = null;
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
                isVIP: isVIP!,
                id: 1,
              )),
    );

    print("📢 Dữ liệu nhận được từ ChooseTimeScreen: $result"); // Debug
    print("startTime: $startTime - $endTime");

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        selectTime = result['selectTime'] ?? "";
        selectedWorkTimeId = result['worktimeid'] ?? "";
        startTime = result['startTime'] ?? "";
        endTime = result['endTime'] ?? "";
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
                  // _buildOptionCard(
                  //   icon: Icons.health_and_safety_outlined,
                  //   title: selectedSpecialtyName ?? 'Chuyên khoa',
                  //   onTap: _selectSpecialty,
                  // ),
                  // _buildOptionCard(
                  //   icon: Icons.person,
                  //   title: selectedDoctorName ?? 'Bác sĩ',
                  //   onTap: isVIP! && selectedSpecialtyId == null
                  //       ? null
                  //       : _selectDoctor, // Nếu VIP mà chưa chọn bác sĩ -> Không cho chọn chuyên khoa
                  //   enabled: isVIP!
                  //       ? selectedSpecialtyId != null
                  //       : true, // Nếu VIP thì phải chọn bác sĩ trước
                  // ),
                  _buildOptionCard(
                      icon: Icons.calendar_today,
                      title: selectDate != null
                          ? formatDate(selectDate!)
                          : 'Ngày khám',
                      onTap: _selectDate,
                      enabled: true),
                  _buildOptionCard(
                    icon: Icons.access_time,
                    title: selectTime ?? 'Giờ khám',
                    onTap: _selectTime,
                    enabled: true,
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
                  onPressed: () async {
                    print(
                        "WORKTIME: ${selectDate} \n startTime: ${startTime} \n endTime: ${endTime}  \n ID: ${widget.appointmentVIPID}");
                    bool checkUpadete =
                        await GetAppointmentApi.UpdateVIPAppointment(
                            worktime: selectDate!,
                            startTime: startTime!,
                            endTime: endTime!,
                            appointmentVIPID: widget.appointmentVIPID);

                    if (checkUpadete) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Thẩy đổi thành công"),
                            duration: Duration(seconds: 2)),
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatientFilePage(
                                    title: "Lịch khám",
                                  )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Vui lòng chọn thông tin chính xác"),
                            duration: Duration(seconds: 2)),
                      );
                    }
                  },
                  child: const Text('Xác nhận'),
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
