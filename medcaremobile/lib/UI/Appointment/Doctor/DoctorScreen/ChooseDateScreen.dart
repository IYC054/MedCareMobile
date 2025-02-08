import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';
import 'package:medcaremobile/services/GetDoctorWorking.dart';
import 'package:table_calendar/table_calendar.dart';

class Choosedatescreen extends StatefulWidget {
  const Choosedatescreen({super.key, required this.id});
  final int id;

  @override
  ChoosedatescreenState createState() => ChoosedatescreenState();
}

class ChoosedatescreenState extends State<Choosedatescreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int? _selectedWorkId; // ID bác sĩ tương ứng với ngày chọn
  List<Map<String, dynamic>> workDates = []; // Chứa ngày làm việc và ID bác sĩ
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
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
        print("Danh sách ngày làm việc: $workDates");
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      return workDates
                          .any((date) => isSameDay(date['workDate'], day));
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
                          return Container(
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color:
                                  Colors.green, // Ngày có thể chọn có nền xanh
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
              ],
            ),
    );
  }
}
