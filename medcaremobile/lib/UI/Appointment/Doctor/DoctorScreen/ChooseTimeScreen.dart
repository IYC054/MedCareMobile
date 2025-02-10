import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';
import 'package:medcaremobile/services/GetDoctorWorking.dart';

class ChooseTimeScreen extends StatefulWidget {
  const ChooseTimeScreen({super.key, required this.id});
  final int id;
  @override
  State<StatefulWidget> createState() => ChooseTimeScreenState();
}

class ChooseTimeScreenState extends State<ChooseTimeScreen> {
  List<dynamic> doctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  void fetchDoctors() async {
    final fetchedDoctors = await Getdoctorworking.fetchDoctorsTime(widget.id);

    if (fetchedDoctors is List) {
      setState(() {
        doctors = fetchedDoctors.map<Map<String, dynamic>>((doctor) {
          return {
            "id": doctor["id"],
            "startTime": doctor["startTime"] ?? "00:00:00",
            "endTime": doctor["endTime"] ?? "00:00:00",
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

  @override
  Widget build(BuildContext context) {
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
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, {
          "worktimeid": doctor["id"],
          "selectTime": timeSlot,
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue),
        ),
        child: Text(
          timeSlot,
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}
