import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';
import 'package:medcaremobile/services/GetAppointmentApi.dart';
import 'package:medcaremobile/services/GetDoctorApi.dart';
import 'package:medcaremobile/services/GetDoctorWorking.dart';
import 'package:medcaremobile/services/IpNetwork.dart';
import 'package:table_calendar/table_calendar.dart';

class Choosedatescreen extends StatefulWidget {
  const Choosedatescreen(
      {super.key, required this.id, this.doctoId, this.isVIP});
  final int id;
  final int? doctoId;
  final bool? isVIP;
  @override
  ChoosedatescreenState createState() => ChoosedatescreenState();
}

class ChoosedatescreenState extends State<Choosedatescreen> {
  List<Map<String, dynamic>> appointments = [];
  List<dynamic> vipappointments = [];
  static const ip = Ipnetwork.ip;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int? _selectedWorkId; // ID bác sĩ tương ứng với ngày chọn
  List<Map<String, dynamic>> workDates = []; // Chứa ngày làm việc và ID bác sĩ
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
    fetchAppointments();
    fetchVipAppointments();
    print("AVC: ${widget.doctoId}");
  }

  Future<void> fetchVipAppointments() async {
    final fetchVipAppointment =
        await GetAppointmentApi.fetchVipAppointmentbyDoctorId(widget.doctoId!);
    print(fetchVipAppointment); // Kiểm tra dữ liệu từ API
    if (fetchVipAppointment != null) {
      setState(() {
        vipappointments = fetchVipAppointment.map((item) {
          return {
            "id": item["id"],
            "date": item["workDate"],
            "reason": item["type"],
            "status": item["status"],
          };
        }).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAppointments() async {
    String apiUrl =
        "http://$ip:8080/api/appointment/doctors/${widget.doctoId!}";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes);
        List<dynamic> data = jsonDecode(utf8Decoded);
        setState(() {
          appointments = data.map((item) {
            return {
              "id": item["id"],
              "date": item["worktime"]["workDate"],
              "reason": item["type"],
              "status": item["payments"] != null && item["payments"].isNotEmpty
                  ? item["payments"][0]
                      ["status"] // Lấy status của payment đầu tiên
                  : "Không có thanh toán",
              "paymentId":
                  item["payments"] != null && item["payments"].isNotEmpty
                      ? item["payments"][0]["id"] // Lấy ID của payment đầu tiên
                      : null,
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load appointments");
      }
    } catch (e) {
      print("Error fetching appointments: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchDoctors() async {
    final fetchedDoctors =
        await Getdoctorworking.fetchDoctorsWorking(widget.id);

    if (fetchedDoctors != null) {
      setState(() {
        workDates = fetchedDoctors.map<Map<String, dynamic>>((doctor) {
          DateTime parsedDate = DateTime.parse(doctor['workDate']);
          return {
            "workDate": DateTime(parsedDate.year, parsedDate.month,
                parsedDate.day), // Chỉ lấy ngày
            "id": doctor['id'], // Lấy ID bác sĩ từ API
          };
        }).toList();
        // print("Danh sách ngày làm việc: $workDates");
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  int getAppointmentCount(DateTime day) {
    return appointments
            .where((appt) => isSameDay(DateTime.parse(appt['date']), day))
            .length +
        vipappointments
            .where((vip) => isSameDay(DateTime.parse(vip['date']), day))
            .length;
  }

  @override
  Widget build(BuildContext context) {
    print(
        "appoitnemnt ${appointments.length} - ${vipappointments.length} doctorID: ${widget.doctoId}");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn ngày khám'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _selectedDay);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ProgressBar(currentStep: 2),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: CalendarFormat.month,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      final selectedWorkDate = workDates.firstWhere(
                        (date) => isSameDay(date['workDate'], selectedDay),
                        orElse: () => {},
                      );
                      int totalAppointments = getAppointmentCount(selectedDay);

                      if (totalAppointments > 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Ngày này đã đầy lịch hẹn!"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      if (selectedWorkDate.isNotEmpty) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _selectedWorkId =
                              selectedWorkDate['id']; // Lấy ID bác sĩ
                          _focusedDay = focusedDay;
                        });
                      }
                    },
                    enabledDayPredicate: (day) {
                      return true; // Chỉ disable nếu số lịch vượt quá 10
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      disabledTextStyle: TextStyle(color: Colors.grey),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        bool isWorkDate = workDates
                            .any((date) => isSameDay(date['workDate'], day));

                        if (isWorkDate) {
                          int countAppointments = appointments
                              .where((appointment) => isSameDay(
                                  DateTime.parse(appointment["date"]), day))
                              .length;
                          int countVipAppointments = vipappointments
                              .where((vip) =>
                                  isSameDay(DateTime.parse(vip["date"]), day))
                              .length;

                          int totalAppointments =
                              countAppointments + countVipAppointments;

                          Color bgColor =
                              Colors.green; // Mặc định màu xanh (Còn trống)
                          if (totalAppointments > 10) {
                            bgColor = Colors.red; // Nếu > 10, màu đỏ (Đã hết)
                          } else if (totalAppointments > 2) {
                            bgColor =
                                Colors.amber; // Nếu > 2, màu vàng (Gần đầy)
                          }

                          return Container(
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: bgColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatusBox(Colors.green, "Còn trống"),
                    SizedBox(width: 10),
                    _buildStatusBox(Colors.amber, "Gần đầy"),
                    SizedBox(width: 10),
                    _buildStatusBox(Colors.red, "Đã hết"),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _selectedDay != null && _selectedWorkId != null
                        ? () {
                            Navigator.pop(context, {
                              "selectDate": _selectedDay,
                              "workId": _selectedWorkId,
                            });
                          }
                        : null,
                    child: const Text('Xác nhận'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }

  Widget _buildStatusBox(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
