import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseDoctor.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseDoctorVIP.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/UpdateDoctorVip.dart';
import 'package:medcaremobile/UI/Viewpayment/PaymentWebView.dart';
import 'package:medcaremobile/services/GetAppointmentApi.dart';
import 'package:medcaremobile/services/GetPatientApi.dart';
import 'dart:convert';

import 'package:medcaremobile/services/IpNetwork.dart';
import 'package:medcaremobile/services/PaymentApi.dart';
import 'package:medcaremobile/services/StorageService.dart';

class PatientFilePage extends StatefulWidget {
  const PatientFilePage({super.key, required this.title});
  final String title;

  @override
  State<PatientFilePage> createState() => _PatientFilePageState();
}

class _PatientFilePageState extends State<PatientFilePage> {
  List<Map<String, dynamic>> appointments = [];
  List<dynamic> vipappointments = [];
  bool isLoading = true;
  bool isVipSelected = false; // Thêm biến để kiểm tra trạng thái chọn nút Vip
  static const ip = Ipnetwork.ip;
  static Map<String, dynamic>? user;
  List<dynamic> patientID = [];
  @override
  void initState() {
    super.initState();
    fetchPatientData();
    loadUserData();
  }

  // Method to load user data asynchronously
  Future<void> loadUserData() async {
    user = await StorageService.getUser();
    if (user != null) {
      fetchAppointments();
      print("Lay patient Data: $user");
    } else {
      print("No user data found. $user");
    }
  }

  Future<void> fetchPatientData() async {
    if (user == null || !user!.containsKey('id')) {
      loadUserData();
    }
    final fetchedProfiles =
        await Getpatientapi.getPatientbyAccountid(user!['id']);

    setState(() {
      patientID = fetchedProfiles;
      print("FEADSADADSA: $fetchedProfiles");
    });
    if (patientID.isNotEmpty) {
      fetchAppointments(); // Gọi fetchAppointments sau khi có patientID
    }
  }

  Future<void> fetchVipAppointments() async {
    final fetchVipAppointment =
        await GetAppointmentApi.fetchVipAppointmentbyPatientId(
            patientID[0]['id']);
    print(fetchVipAppointment); // Kiểm tra dữ liệu từ API
    if (fetchVipAppointment != null) {
      setState(() {
        appointments = fetchVipAppointment.map((item) {
          var matchedSpecialty = item['doctor']['specialties'].firstWhere(
            (specialty) => specialty['name'] == item['type'],
            orElse: () => null, // Trả về null nếu không tìm thấy
          );
          return {
            "id": item["id"],
            "date": item["workDate"],
            "reason": item["type"],
            "status": "Đã thanh toán",
            "examination": item["status"],
            "startTime": item["startTime"],
            "endTime": item["endTime"],
            "profileID": item["patientprofile"]["id"],
            "doctor_id": item['doctor']['id'],
            "doctor_name": item['doctor']['account']['name'],
            "specialty_id":
                matchedSpecialty != null ? matchedSpecialty['id'] : null,
            "specialty_name":
                matchedSpecialty != null ? matchedSpecialty['name'] : null,
            "patient_name": item['patientprofile']['fullname'],
            "patientprofile_id": item['patientprofile']['id'],
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

  Future<void> _handlePayment(int paymentID) async {
    String? token = await StorageService.getToken();
    String apiUrl = 'http://$ip:8080/api/payments/create-payment';

    try {
      final response = await http.post(
          Uri.parse("$apiUrl?amount=150000&orderInfo=thanh toán medcare"),
          headers: {
            "Content-Type": "application/json",
          });
      if (response.statusCode == 200) {
        String paymentUrl = response.body;
        if (paymentUrl.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentWebView(
                paymentUrl: paymentUrl,
                isNormal: false,
                PaymentID: paymentID,
              ),
            ),
          );
        } else {
          throw 'Không thể mở đường dẫn: URL rỗng!';
        }
      } else {
        throw 'Lỗi khi gọi API thanh toán';
      }
    } catch (e) {
      print('Lỗi khi gọi API thanh toán: $e');
    }
  }

  Future<void> fetchAppointments() async {
    if (patientID.isEmpty) {
      print("PatientID rỗng, không thể lấy dữ liệu lịch hẹn.");
      return; // Ngăn việc gọi API khi chưa có patientID
    }

    String apiUrl =
        "http://$ip:8080/api/appointment/patient/${patientID[0]['id']}";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes);
        List<dynamic> data = jsonDecode(utf8Decoded);

        if (data.isEmpty) {
          print("Không có cuộc hẹn nào được tìm thấy.");
          setState(() {
            isLoading = false;
            appointments = [];
          });
          return;
        }

        setState(() {
          appointments = data.map((item) {
            print("APPOINT DATA: $item");

            var matchedSpecialty = item['doctor']['specialties'].firstWhere(
              (specialty) => specialty['name'] == item['type'],
              orElse: () => null,
            );

            return {
              "id": item["id"],
              "date": item["worktime"]["workDate"],
              "startTime": item['worktime']['startTime'],
              "endTime": item['worktime']['endTime'],
              "doctor_id": item['doctor']['id'],
              "doctor_name": item['doctor']['account']['name'],
              "specialty_id":
                  matchedSpecialty != null ? matchedSpecialty['id'] : null,
              "specialty_name":
                  matchedSpecialty != null ? matchedSpecialty['name'] : null,
              "patient_name": item['patientprofile']['fullname'],
              "patientprofile_id": item['patientprofile']['id'],
              "reason": item["type"],
              "examination": item['status'],
              "status": item["payments"].isNotEmpty
                  ? item["payments"][0]["status"]
                  : "Chưa thanh toán",
              "paymentId":
                  item["payments"].isNotEmpty ? item["payments"][0]["id"] : null
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

  void ShowUpdateStatus(BuildContext context, int appId, bool isVIP,
      int paymentID, String appointmentStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thông báo"),
          content: Text("Bạn có chắc muốn huỷ cuộc hẹn?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Không"),
            ),
            TextButton(
              onPressed: () async {
                bool checkstatus;
                String? transcode;

                // Gọi API hủy cuộc hẹn
                if (isVIP) {
                  checkstatus =
                      await GetAppointmentApi.UpdateStatusVIPAppointment(appId);
                } else {
                  checkstatus =
                      await GetAppointmentApi.UpdateStatusAppointment(appId);
                }

                // Chỉ cập nhật trạng thái payment nếu cuộc hẹn đã thanh toán
                if (appointmentStatus.contains("Đã thanh toán")) {
                  transcode = await Paymentapi.UpdatestatusPayment(
                      paymentID: paymentID, status: "Hoàn tiền");
                } else {
                  transcode =
                      "No Payment Update"; // Chỉ để check, không gọi API
                }

                if (checkstatus && transcode != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Đã huỷ hẹn thành công"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  fetchPatientData();
                  fetchAppointments();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("Huỷ hẹn chưa thành công, xin vui lòng thử lại"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text("Có"),
            ),
          ],
        );
      },
    );
  }

  void ShowalertPayment(BuildContext context, int appId, bool isvip,
      int paymentID, String appointmentStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thông báo"),
          content: Text(
              "Bạn đã thanh toán cho cuộc hẹn này, vui lòng liện hệ với nhân viên để xử lý thanh toán nếu bạn huỷ!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Không huỷ"),
            ),
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                Future.delayed(Duration(milliseconds: 500), () {
                  if (context.mounted) {
                    ShowUpdateStatus(
                        context, appId, isvip, paymentID, appointmentStatus);
                  }
                });
              },
              child: Text("Tiếp tục huỷ"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.blue.shade700,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                widget.title,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isVipSelected = false; // Chọn Khám Thường
                        isLoading = true;
                      });
                      fetchAppointments(); // Gọi lại API cho "Khám Thường"
                    },
                    child: Text(
                      "Khám Thường",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Màu nền của nút
                      padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12), // Padding bên trong nút
                      textStyle: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold), // Cỡ chữ
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Bo tròn các góc nút
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isVipSelected = true; // Chọn Khám Vip
                        isLoading = true;
                      });
                      fetchVipAppointments(); // Gọi lại API cho "Khám Vip"
                    },
                    child: Text(
                      "Khám Vip",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Màu nền của nút
                      padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12), // Padding bên trong nút
                      textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white), // Cỡ chữ
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Bo tròn các góc nút
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : appointments.isEmpty
                      ? const Center(
                          child: Text(
                            "Bạn chưa có cuộc hẹn nào",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.separated(
                            itemCount: appointments
                                .where((appointment) =>
                                    appointment['status']?.toString()?.trim() !=
                                    "Đã huỷ")
                                .length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final appointment = appointments[index];
                              print("ISVIP: $isVipSelected");
                              print(
                                  "ID: ${appointment['specialty_id']} \n ${appointment['specialty_name']} ${appointment['patient_name']}");
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                  border: Border.all(
                                      color: Colors.blue.shade200, width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today,
                                              size: 22, color: Colors.blue),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Ngày hẹn: ${appointment["date"]}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.timelapse_outlined,
                                              size: 22, color: Colors.blue),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              "Thời gian: ${appointment["startTime"]} - ${appointment["endTime"]}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.local_hospital,
                                              size: 22,
                                              color: Colors.redAccent),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              "Chuyên khoa: ${appointment["reason"]}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.check_circle,
                                              size: 22, color: Colors.green),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Trạng thái: ${appointment["examination"]}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.credit_card,
                                              size: 22, color: Colors.green),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Trạng thái thanh toán: ${appointment["status"]}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          String base64QRCode =
                                              await GetAppointmentApi
                                                  .GenerateQRApointment(
                                                      appointment["id"],
                                                      isVipSelected);
                                          if (base64QRCode.isNotEmpty) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Image.memory(
                                                          base64Decode(
                                                              base64QRCode),
                                                          width: 200,
                                                          height: 200,
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Text('QR Code',
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(Icons.qr_code_2,
                                                size: 22, color: Colors.grey),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Bấm vào để hiện thị QR",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      if (appointment['status']
                                              .toString()
                                              .contains("Chưa thanh toán") &&
                                          !appointment['examination']
                                              .toString()
                                              .trim()
                                              .contains("Đã huỷ"))
                                        GestureDetector(
                                          onTap: () {
                                            _handlePayment(
                                                appointment['paymentId']);
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.payment,
                                                  size: 22,
                                                  color: Colors.green),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Bấm vào để thanh toán",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      isVipSelected
                                          ? SizedBox(height: 10)
                                          : SizedBox.shrink(),
                                      if (isVipSelected)
                                        GestureDetector(
                                          onTap: () {
                                            DateTime today = DateTime.now();
                                            today = DateTime(
                                                today.year,
                                                today.month,
                                                today.day); // Đặt về 00:00:00

                                            DateTime appointmentDate =
                                                DateTime.parse(
                                                    appointment['date']);
                                            appointmentDate = DateTime(
                                                appointmentDate.year,
                                                appointmentDate.month,
                                                appointmentDate.day);

                                            Duration difference =
                                                appointmentDate
                                                    .difference(today);

                                            if (difference.inDays < 1) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Bạn chỉ có thể thay đổi lịch hẹn trước 1 ngày!")));
                                              return;
                                            }
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Updatedoctorvip(
                                                          appointmentVIPID:
                                                              appointment['id'],
                                                          selectProfileID:
                                                              appointment[
                                                                  'profileID'],
                                                        )));
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.update,
                                                  size: 22,
                                                  color: Colors.amber),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Thay đổi lịch hẹn",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      if (!appointment['examination']
                                          .toString()
                                          .trim()
                                          .contains("Đã huỷ"))
                                        GestureDetector(
                                          onTap: () {
                                            DateTime today = DateTime.now();
                                            today = DateTime(
                                                today.year,
                                                today.month,
                                                today.day); // Đặt về 00:00:00

                                            DateTime appointmentDate =
                                                DateTime.parse(
                                                    appointment['date']);
                                            appointmentDate = DateTime(
                                                appointmentDate.year,
                                                appointmentDate.month,
                                                appointmentDate.day);

                                            Duration difference =
                                                appointmentDate
                                                    .difference(today);

                                            if (difference.inDays < 1) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Bạn chỉ có thể huỷ lịch hẹn trước 1 ngày!")));
                                              return;
                                            }
                                            if (appointment['status']
                                                .toString()
                                                .contains("Chưa thanh toán")) {
                                              ShowUpdateStatus(
                                                context,
                                                appointment['id'],
                                                isVipSelected,
                                                appointment['paymentId'],
                                                appointment['status'],
                                              );
                                            } else {
                                              ShowalertPayment(
                                                  context,
                                                  appointment['id'],
                                                  isVipSelected,
                                                  appointment['paymentId'],
                                                  appointment['status']);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.block,
                                                  size: 22, color: Colors.red),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Huỷ lịch hẹn",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      isVipSelected
                                          ? SizedBox(height: 10)
                                          : SizedBox(height: 10),
                                      if (appointment['examination']
                                          .toString()
                                          .trim()
                                          .contains("Hoàn thành"))
                                        GestureDetector(
                                          onTap: () {
                                            print(
                                                "ID: ${appointment['specialty_id']} \n name ${appointment['patient_name']} \n specialty_id ${appointment['specialty_id']} \n specialty_name ${appointment['specialty_name']} \n doctor_id: ${appointment['doctor_id']} \n doctor_name: ${appointment['doctor_name']}");
                                            if (isVipSelected) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Choosedoctorvip(
                                                          isVIP: true,
                                                          profileId: appointment[
                                                              'patientprofile_id'],
                                                          patientname:
                                                              appointment[
                                                                  'patient_name'],
                                                          reselectedSpecialtyId:
                                                              appointment[
                                                                  'specialty_id'],
                                                          reselectedSpecialtyName:
                                                              appointment[
                                                                  'specialty_name'],
                                                          reselectedDoctorId:
                                                              appointment[
                                                                  'doctor_id'],
                                                          resselectedDoctorName:
                                                              appointment[
                                                                  'doctor_name'],
                                                        )),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Choosedoctor(
                                                          profileId: appointment[
                                                              'patientprofile_id'],
                                                          patientname:
                                                              appointment[
                                                                  'patient_name'],
                                                          reselectedSpecialtyId:
                                                              appointment[
                                                                  'specialty_id'],
                                                          reselectedSpecialtyName:
                                                              appointment[
                                                                  'specialty_name'],
                                                          reselectedDoctorId:
                                                              appointment[
                                                                  'doctor_id'],
                                                          resselectedDoctorName:
                                                              appointment[
                                                                  'doctor_name'],
                                                        )),
                                              );
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.book,
                                                  size: 22,
                                                  color:
                                                      Colors.deepOrangeAccent),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Tái khám",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
