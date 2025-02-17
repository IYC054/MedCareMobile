import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseBill.dart';
import 'package:medcaremobile/services/GetAppointmentApi.dart';
import 'package:medcaremobile/services/PaymentApi.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final int profileId;
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

  final bool? isVIP;
  const PaymentWebView(
      {required this.paymentUrl,
      required this.profileId,
      this.selectedDoctorId,
      this.selectedSpecialtyName,
      this.selectedSpecialtyId,
      this.selectedWorkTimeId,
      this.patientName,
      this.selectDate,
      this.selectTime,
      this.Doctorname,
      this.isVIP,
      this.startTime,
      this.endTime});

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  InAppWebViewController? webViewController;

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  bool _isPaymentCompleted = false;

  @override
  Widget build(BuildContext context) {
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

                  if (transactionStatus == "00") {
                    await controller.stopLoading();
                    setState(() {
                      _isPaymentCompleted = true;
                    });
                    if (widget.isVIP == true) {
                      _handlePaymentSuccessISVIP();
                    } else {
                      _handlePaymentSuccessNOVIP();
                    }
                  } else {
                    print("Thanh toán thất bại hoặc bị hủy.");
                  }
                }
              },
            ),
    );
  }

  void _handlePaymentSuccessISVIP() async {
    try {
      int bookingId = await GetAppointmentApi.createVIPAppointment(
          patientId: 1,
          doctorId: widget.selectedDoctorId!,
          specialty: widget.selectedSpecialtyName!,
          patientProfileId: widget.profileId,
          startTime: widget.startTime!,
          endTime: widget.endTime!,
          worktime: DateTime.parse(widget.selectDate.toString()));
      String? transcode =
          await Paymentapi.createPayment(appointmentid: bookingId, amount: 300000, isVIP: widget.isVIP!);
  
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
      int bookingId = await GetAppointmentApi.createAppointment(
        patientId: 1,
        doctorId: widget.selectedDoctorId!,
        specialty: widget.selectedSpecialtyName!,
        worktimeId: widget.selectedWorkTimeId!,
        patientProfileId: widget.profileId,
      );
      String? transcode =
          await Paymentapi.createPayment(appointmentid: bookingId,amount: 150000, isVIP: widget.isVIP!);
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
