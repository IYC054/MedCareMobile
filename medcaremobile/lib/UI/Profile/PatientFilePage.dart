import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/UI/Appointment/Doctor/UpdateDoctorVip.dart';
import 'package:medcaremobile/UI/Viewpayment/PaymentWebView.dart';
import 'package:medcaremobile/services/GetAppointmentApi.dart';
import 'package:medcaremobile/services/GetPatientApi.dart';
import 'dart:convert';

import 'package:medcaremobile/services/IpNetwork.dart';
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
    fetchAppointments(); // Mặc định load "Khám Thường"
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
          print("VIP: $item['id']");
          return {
            "id": item["id"],
            "date": item["workDate"],
            "reason": item["type"],
            "status": "Đã thanh toán",
            "examination": item["status"],
            "startTime": item["startTime"],
            "endTime": item["endTime"],
            "profileID": item["patientprofile"]["id"],
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
    String apiUrl =
        "http://$ip:8080/api/appointment/patient/${patientID[0]['id']}";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes);
        List<dynamic> data = jsonDecode(utf8Decoded);
        setState(() {
          appointments = data.map((item) {
            print(
                "Item ${item['worktime']['startTime']} - ${item['worktime']['endTime']}");
            return {
              "id": item["id"],
              "date": item["worktime"]["workDate"],
              "startTime": item['worktime']['startTime'],
              "endTime": item['worktime']['endTime'],
              "reason": item["type"],
              "examination": item['status'],
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

  void ShowUpdateStatus(BuildContext context, int appId, isVIP) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thông báo"),
          content: Text("Bạn có chắn muốn huỷ cuộc hẹn?"),
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
                if (isVIP) {
                  checkstatus =
                      await GetAppointmentApi.UpdateStatusVIPAppointment(appId);
                } else {
                  checkstatus =
                      await GetAppointmentApi.UpdateStatusAppointment(appId);
                }
                if (checkstatus) {
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
                          Text("huỷ hẹn chưa thành công xin vui lòng thử lại"),
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

  void ShowalertPayment(BuildContext context, int appId, bool isvip) {
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
          
                    ShowUpdateStatus(context, appId, isvip);
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
                                            if (appointment['status']
                                                .toString()
                                                .contains("Chưa thanh toán")) {
                                              ShowUpdateStatus(
                                                  context,
                                                  appointment['id'],
                                                  isVipSelected);
                                            } else {
                                              ShowalertPayment(
                                                  context,
                                                  appointment['id'],
                                                  isVipSelected);
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
                                        )
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
