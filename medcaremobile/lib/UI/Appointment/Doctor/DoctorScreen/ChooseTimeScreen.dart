import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';
import 'package:medcaremobile/services/GetAppointmentApi.dart';
import 'package:medcaremobile/services/GetDoctorWorking.dart';

class ChooseTimeScreen extends StatefulWidget {
  const ChooseTimeScreen(
      {super.key,
      required this.id,
      required this.isVIP,
      required this.selectedDate});
  final int id;
  final bool isVIP;
  final DateTime selectedDate;
  @override
  State<StatefulWidget> createState() => ChooseTimeScreenState();
}

class ChooseTimeScreenState extends State<ChooseTimeScreen> {
  List<dynamic> doctors = [];
  List<dynamic> VIPApt = [];
  List<String> bookedTimes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
    fetchVipAppointment();
  }

  void fetchVipAppointment() async {
    final fetchedVIPAppointment = await GetAppointmentApi.fetchVipAppointment();
    // print(fetchedVIPAppointment); // Debug dữ liệu API

    if (fetchedVIPAppointment != null) {
      setState(() {
        VIPApt = fetchedVIPAppointment;

        // Lọc danh sách giờ đã đặt theo ngày đã chọn
        bookedTimes = VIPApt.where((apt) =>
                apt["workDate"] ==
                widget.selectedDate.toIso8601String().split('T')[0])
            .map<String>((apt) => apt["startTime"])
            .toList();

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchDoctors() async {
    if (widget.isVIP) {
      setState(() {
        doctors = [
          {"id": 1, "startTime": "06:00", "endTime": "07:00"},
          {"id": 2, "startTime": "08:00", "endTime": "09:00"},
          {"id": 3, "startTime": "10:00", "endTime": "11:00"},
          {"id": 4, "startTime": "13:00", "endTime": "14:00"},
          {"id": 5, "startTime": "15:00", "endTime": "16:00"},
          {"id": 6, "startTime": "17:00", "endTime": "18:00"},
        ];
        isLoading = false;
      });
    } else {
      final fetchedDoctors = await Getdoctorworking.fetchDoctorsTime(widget.id);

      if (fetchedDoctors is List) {
        setState(() {
          doctors = fetchedDoctors.map<Map<String, dynamic>>((doctor) {
            return {
              "id": doctor["id"],
              "startTime": doctor["startTime"] ?? "00:00",
              "endTime": doctor["endTime"] ?? "00:00",
            };
          }).toList();
          isLoading = false;
        });
      } else {
        print("⚠️ Dữ liệu API không hợp lệ: $fetchedDoctors");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        "Ngày đã chọn: ${widget.selectedDate.toIso8601String().split('T')[0]}");
    print("Danh sách giờ đã đặt: $bookedTimes");
    print(
        "Danh sách giờ làm việc của bác sĩ: ${doctors.map((e) => e['startTime'])}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn giờ khám',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressBar(currentStep: 2),
            const SizedBox(height: 24),
            Text('Chọn giờ khám',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Divider(),
                    SizedBox(height: 8),
                    Text('Buổi sáng',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: doctors.map((doctor) {
                        return _buildTimeSlot(context, doctor);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(BuildContext context, Map<String, dynamic> doctor) {
    String timeSlot = "${doctor["startTime"]} - ${doctor["endTime"]}";
    // bool isBooked = bookedTimes.contains("${doctor["startTime"]}:00");
    String startTime = doctor["startTime"];
    int countBooked =
        bookedTimes.where((time) => time.startsWith(startTime)).length;
    bool isFullyBooked = countBooked >= 1; // Nếu >= 5 thì không cho chọn nữa
    return GestureDetector(
      onTap: isFullyBooked
          ? null // Vô hiệu hóa chọn nếu giờ đã đặt
          : () {
              Map<String, dynamic> data = {
                "worktimeid": doctor["id"],
                "selectTime": timeSlot,
                "startTime": doctor["startTime"],
                "endTime": doctor["endTime"]
              };
              print("📤 Gửi dữ liệu: $data");
              Navigator.pop(context, data);
            },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isFullyBooked
              ? Colors.grey[400]
              : Colors.white, // Đổi màu nếu bị đặt
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isFullyBooked ? Colors.grey : Colors.blue),
        ),
        child: Text(
          timeSlot,
          style: TextStyle(
              color: isFullyBooked
                  ? Colors.grey[600]
                  : Colors.blue), // Đổi màu chữ
        ),
      ),
    );
  }
}
