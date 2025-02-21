import 'package:flutter/material.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseBill.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ProgressBar.dart';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/UI/Viewpayment/PaymentWebView.dart';
import 'package:medcaremobile/services/GetAppointmentApi.dart';
import 'package:medcaremobile/services/GetPatientApi.dart';
import 'package:medcaremobile/services/IpNetwork.dart';
import 'package:medcaremobile/services/PaymentApi.dart';
import 'dart:convert';
import 'package:medcaremobile/services/StorageService.dart';
import 'package:show_custom_snackbar/show_custom_snackbar.dart';

class ChoosePaymentScreen extends StatefulWidget {
  const ChoosePaymentScreen({
    super.key,
    required this.specialtyname,
    required this.profileId,
    this.selectedDoctorId,
    this.selectedSpecialtyId,
    this.selectedWorkTimeId,
    this.patientName,
    this.selectDate,
    this.selectTime,
    this.Doctorname,
    this.selectedSpecialtyName,
    this.isVIP,
    this.startTime,
    this.endTime,
  });

  final String specialtyname;
  final int profileId;
  final int? selectedDoctorId;
  final String? Doctorname;
  final String? selectedSpecialtyName;
  final bool? isVIP;
  final int? selectedSpecialtyId;
  final int? selectedWorkTimeId;
  final String? patientName;
  final DateTime? selectDate;
  final String? selectTime;
  final String? startTime;
  final String? endTime;

  @override
  State<ChoosePaymentScreen> createState() => _ChoosePaymentScreenState();
}

class _ChoosePaymentScreenState extends State<ChoosePaymentScreen> {
  String selectedPayment = ''; // Phương thức mặc định
  static const ip = Ipnetwork.ip;
  List<dynamic> patientId = []; // Initialize as an empty list
  static Map<String, dynamic>? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
    loadPatientData();
    print("Patient ID loaded: $patientId");

  }

  // Method to load user data asynchronously
  static Future<void> loadUserData() async {
    user = await StorageService.getUser();
    if (user != null) {
      print("Lay patient Data: $user");
    } else {
      print("No user data found. $user");
    }
  }

  // Constructor

  // Async method to load patient data
  Future<void> loadPatientData() async {
    if (user == null) {
      loadUserData();
    }
    // Wait for the data to be loaded before using it
    patientId = await Getpatientapi.getPatientbyAccountid(user!['id']);
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void selectPayment(String payment) {
    setState(() {
      selectedPayment = payment;
    });
  }

  Future<void> _handlePayment() async {
    String? token = await StorageService.getToken();
    String apiUrl = 'http://$ip:8080/api/payments/create-payment';

    try {
      final response = await http.post(
          Uri.parse(
              "$apiUrl?amount=${widget.isVIP! ? 300000 : 150000}&orderInfo=thanh toán medcare"),
          headers: {
            "Authorization": "Bearer $token",
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
                profileId: widget.profileId,
                patientName: widget.patientName,
                selectedDoctorId: widget.selectedDoctorId,
                selectedSpecialtyId: widget.selectedSpecialtyId,
                selectedWorkTimeId: widget.selectedWorkTimeId,
                selectDate: widget.selectDate,
                selectTime: widget.selectTime,
                Doctorname: widget.Doctorname,
                selectedSpecialtyName: widget.specialtyname,
                isVIP: widget.isVIP,
                startTime: widget.startTime,
                endTime: widget.endTime,
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

  Future<void> _handlePaymentAtHospital() async {
    if (user == null) {
      loadUserData();
    }
    if (patientId == null) {
      loadPatientData();
    }
    try {
      print(
          "doctor: ${widget.selectedDoctorId} \n specialty: ${widget.specialtyname} \n worktimeId: ${widget.selectedWorkTimeId} \n patientProfileId: ${widget.profileId} \n patient: ${patientId[0]}");
      int bookingId = await GetAppointmentApi().createAppointment(
          doctorId: widget.selectedDoctorId!,
          specialty: widget.specialtyname!,
          worktimeId: widget.selectedWorkTimeId!,
          patientProfileId: widget.profileId,
          patientID: patientId[0]['id']);
      if (bookingId != 0) {
        String? transcode = await Paymentapi.createPayment(
            appointmentid: bookingId,
            amount: widget.isVIP! ? 300000 : 150000,
            isVIP: widget.isVIP!,
            status: "Chưa thanh toán");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Choosebill(
              bookingId: transcode!,
              patientName: widget.patientName!,
              paymentTime:
                  "${formatDate(widget.selectDate!)} - ${widget.selectTime!}",
              doctorName: "BS. ${widget.Doctorname}",
              specialization: widget.specialtyname!,
              totalAmount: widget.isVIP! ? "300.000 VND" : "150.000 VND",
            ),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: ShowCustomSnackBar(
            title: "Đặt lịch thành công.",
            label: "",
            color: Colors.green,
            icon: Icons.remove_circle_outline,
          ),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ));
      } else {
        print("Không thể tạo cuộc hẹn.");
      }
    } catch (e) {
      print("Lỗi khi xử lý thanh toán: $e");
    }
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
            ProgressBar(currentStep: 4),
            const SizedBox(height: 24),
            Text(
              'Vui lòng kiểm tra thông tin đăng ký và chọn phương thức thanh toán.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Sau khi thanh toán thành công, bạn vui lòng đợi nhận PHIẾU KHÁM BỆNH, không đóng ứng dụng.',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            Divider(height: 32),
            Text(
              'Chuyên khoa đã chọn (1)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.health_and_safety, color: Colors.red),
              title: Text(widget.specialtyname,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              trailing: Text(widget.isVIP! ? '300.000 đ' : '150.000 đ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Divider(height: 32),
            Text(
              'Phương thức thanh toán',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            PaymentOption(
              title: 'Thanh toán VNPAY',
              imagepath:
                  "https://vinadesign.vn/uploads/thumbnails/800/2023/05/vnpay-logo-vinadesign-25-12-59-16.jpg",
              selected: selectedPayment == 'VNPAY',
              onTap: () => selectPayment('VNPAY'),
            ),
            widget.isVIP ?? false
                ? SizedBox.shrink()
                : PaymentOption(
                    title: 'Thanh toán tại bệnh viện',
                    imagepath:
                        "https://img.freepik.com/premium-vector/hospital-logo-vector_1277164-14255.jpg?w=740",
                    selected: selectedPayment == 'Hospital',
                    onTap: () => selectPayment('Hospital'),
                  ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.isVIP! ? '300.000đ' : '150.000đ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text('Quay lại'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedPayment == "VNPAY") {
                      _handlePayment();
                    } else if (selectedPayment == "Hospital") {
                      _handlePaymentAtHospital();
                    }
                  },
                  child: Text('Thanh toán'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentOption extends StatelessWidget {
  final String title;
  final String imagepath;
  final bool selected;
  final VoidCallback onTap;

  const PaymentOption({
    required this.title,
    required this.imagepath,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: onTap,
          leading: Image.network(
            imagepath,
            width: 30,
            height: 30,
          ),
          title: Text(title),
          trailing: selected
              ? Icon(Icons.check_circle, color: Colors.green)
              : Icon(Icons.circle_outlined, color: Colors.grey),
        ),
        Divider(),
      ],
    );
  }
}
