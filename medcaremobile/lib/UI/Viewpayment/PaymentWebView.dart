import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseBill.dart';
import 'package:medcaremobile/UI/Profile/PatientFilePage.dart';
import 'package:medcaremobile/UI/Profile/ProfilePage.dart';
import 'package:medcaremobile/services/GetAppointmentApi.dart';
import 'package:medcaremobile/services/GetPatientApi.dart';
import 'package:medcaremobile/services/PaymentApi.dart';
import 'package:medcaremobile/services/StorageService.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final int? profileId;
  final int? selectedDoctorId;
  final String? selectedSpecialtyName;
  final String? Doctorname;
  final int? selectedSpecialtyId;
  final int? selectedWorkTimeId;
  final String? patientName;
  final DateTime? selectDate;
  final String? selectTime;
  final String? startTime;
  final String? endTime;
  final bool? isNormal;
  final int? PaymentID;

  final bool? isVIP;
  const PaymentWebView(
      {required this.paymentUrl,
      this.profileId,
      this.selectedDoctorId,
      this.selectedSpecialtyName,
      this.selectedSpecialtyId,
      this.selectedWorkTimeId,
      this.patientName,
      this.selectDate,
      this.selectTime,
      this.Doctorname,
      this.isVIP = false,
      this.startTime,
      this.endTime,
      this.isNormal = true,
      this.PaymentID = 0});

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  InAppWebViewController? webViewController;
  List<dynamic> patientId = []; // Initialize as an empty list
  static Map<String, dynamic>? user;

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
    print("Patient ID loaded: $patientId");
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  bool _isPaymentCompleted = false;

  @override
  Widget build(BuildContext context) {
    print('''
profileId: ${widget.profileId}
selectedDoctorId: ${widget.selectedDoctorId}
selectedSpecialtyName: ${widget.selectedSpecialtyName}
selectedSpecialtyId: ${widget.selectedSpecialtyId}
selectedWorkTimeId: ${widget.selectedWorkTimeId}
patientName: ${widget.patientName}
selectDate: ${widget.selectDate}
selectTime: ${widget.selectTime}
Doctorname: ${widget.Doctorname}
isVIP: ${widget.isVIP}
startTime: ${widget.startTime}
endTime: ${widget.endTime}
isNormal: ${widget.isNormal}
PaymentID: ${widget.PaymentID}
''');

    return Scaffold(
      appBar: AppBar(title: Text("Thanh toán VNPAY")),
      body: _isPaymentCompleted
          ? Center(child: CircularProgressIndicator()) // Hoặc giao diện khác
          : InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.paymentUrl)),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStop: (controller, url) async {
                if (url != null) {
                  print("URL thanh toán: $url");
                  Uri uri = Uri.parse(url.toString());
                  String? transactionStatus =
                      uri.queryParameters["vnp_TransactionStatus"];
                  print("NORMAL: ${widget.isNormal} VIP: ${widget.isVIP}");
                  if (transactionStatus == "00") {
                    await controller.stopLoading();
                    setState(() {
                      _isPaymentCompleted = true;
                    });
                    if (widget.isVIP == true && widget.isNormal! == true) {
                      _handlePaymentSuccessISVIP();
                    } else {
                      _handlePaymentSuccessNOVIP();
                    }
                    if (widget.isNormal! == false && widget.isVIP == false) {
                      _handlePaymentAppointment();
                    }
                  } else {
                    print("Thanh toán thất bại hoặc bị hủy.");
                  }
                }
              },
            ),
    );
  }

  void _handlePaymentAppointment() async {
    String? transcode =
        await Paymentapi.UpdatestatusPayment(paymentID: widget.PaymentID!);
    if (transcode != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PatientFilePage(
                    title: "Lịch khám",
                  )));
    }
  }

  void _handlePaymentSuccessISVIP() async {
    try {
      int bookingId = await GetAppointmentApi().createVIPAppointment(
          doctorId: widget.selectedDoctorId!,
          specialty: widget.selectedSpecialtyName!,
          patientProfileId: widget.profileId!,
          startTime: widget.startTime!,
          endTime: widget.endTime!,
          patientID: patientId[0]['id'],
          worktime: DateTime.parse(widget.selectDate.toString()));
      String? transcode = await Paymentapi.createPayment(
          appointmentid: bookingId,
          amount: 300000,
          isVIP: widget.isVIP!,
          status: "Đã thanh toán");

      if (bookingId != 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Choosebill(
              bookingId: transcode!,
              patientName: widget.patientName!,
              paymentTime:
                  "${formatDate(widget.selectDate!)} - ${widget.selectTime!}",
              doctorName: "BS. ${widget.Doctorname}",
              specialization: widget.selectedSpecialtyName!,
              totalAmount: "300.00 VND",
            ),
          ),
        );
      } else {
        print("Không thể tạo cuộc hẹn.");
      }
    } catch (e) {
      print("Lỗi khi xử lý thanh toán: $e");
    }
  }

  void _handlePaymentSuccessNOVIP() async {
    try {
      int bookingId = await GetAppointmentApi().createAppointment(
        doctorId: widget.selectedDoctorId!,
        specialty: widget.selectedSpecialtyName!,
        worktimeId: widget.selectedWorkTimeId!,
        patientProfileId: widget.profileId!,
        patientID: patientId[0]['id'],
      );
      String? transcode = await Paymentapi.createPayment(
          appointmentid: bookingId,
          amount: 150000,
          isVIP: widget.isVIP!,
          status: "Đã thanh toán");
      if (bookingId != 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Choosebill(
              bookingId: transcode!,
              patientName: widget.patientName!,
              paymentTime:
                  "${formatDate(widget.selectDate!)} - ${widget.selectTime!}",
              doctorName: "BS. ${widget.Doctorname}",
              specialization: widget.selectedSpecialtyName!,
              totalAmount: "150.000 VND",
            ),
          ),
        );
      } else {
        print("Không thể tạo cuộc hẹn.");
      }
    } catch (e) {
      print("Lỗi khi xử lý thanh toán: $e");
    }
  }
}
