import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseBill.dart';
import 'package:medcaremobile/UI/Profile/PatientFilePage.dart';
import 'package:medcaremobile/services/GetAppointmentApi.dart';
import 'package:medcaremobile/services/GetPatientApi.dart';
import 'package:medcaremobile/services/PaymentApi.dart';
import 'package:medcaremobile/services/StorageService.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final int? profileId,
      selectedDoctorId,
      selectedSpecialtyId,
      selectedWorkTimeId,
      PaymentID;
  final String? selectedSpecialtyName,
      Doctorname,
      patientName,
      selectTime,
      startTime,
      endTime,
      TypePayment;
  final DateTime? selectDate;
  final bool? isNormal, isVIP;

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
      this.PaymentID = 0,
      this.TypePayment});

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView>
    with WidgetsBindingObserver {
  InAppWebViewController? webViewController;
  List<dynamic> patientId = [];
  static Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadUserData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> loadUserData() async {
    user = await StorageService.getUser();
    if (user != null) loadPatientData();
  }

  Future<void> loadPatientData() async {
    patientId = await Getpatientapi.getPatientbyAccountid(user!['id']);
  }

  String fixPaymentUrl(String url) => url.replaceAll("momo://app", "").trim();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(
        "App state changed: $state"); // Kiểm tra xem app có nhận sự kiện resume không
    if (state == AppLifecycleState.resumed) {
      _checkPaymentStatus();
    }
  }

  void _checkPaymentStatus() async {
    await Future.delayed(Duration(seconds: 2)); // Chờ 2 giây
    String? currentUrl = (await webViewController?.getUrl())?.toString();
    print("Current URL: $currentUrl");

    if (currentUrl != null) {
      Uri uri = Uri.parse(currentUrl);
      if (uri.queryParameters["vnp_TransactionStatus"] == "00" ||
          uri.queryParameters["resultCode"] == "0") {
        Navigator.pop(context, true);
      }
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<String?> fetchSuccessMessage(urls) async {
    final url = Uri.parse(urls);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var document = parse(response.body); // Parse HTML
        var successText =
            document.querySelector("p")?.text; // Lấy nội dung của <p>

        if (successText != null && successText.contains("Thành công")) {
          return successText;
        }
      }
    } catch (e) {
      print("Lỗi khi lấy dữ liệu: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thanh toán MEDCARE")),
      body: InAppWebView(
          initialUrlRequest:
              URLRequest(url: WebUri(fixPaymentUrl(widget.paymentUrl))),
          onWebViewCreated: (controller) => webViewController = controller,
          onLoadStop: (controller, url) async {
            if (url != null) {
              String source =
                  url.toString(); // Lưu giá trị URL hiện tại vào biến source
              Uri uri = Uri.parse(source);

              // Nếu source chứa một URL hợp lệ, cập nhật lại uri
              String? message = await fetchSuccessMessage(source);
              print("message $message");
              bool isSuccess =
                  message != null && message.contains("Thành công.");
              if (uri.queryParameters["vnp_TransactionStatus"] == "00" ||
                  isSuccess) {
                await controller.stopLoading();
                setState(() {});
                widget.isVIP == true && widget.isNormal == true
                    ? _handlePaymentSuccessISVIP()
                    : _handlePaymentSuccessNOVIP();
                if (widget.isNormal == false && widget.isVIP == false)
                  _handlePaymentAppointment();
              }
            }
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var url = navigationAction.request.url.toString();
            print("Intercepted URL: $url");

            if (url.startsWith("momo://") ||
                url.startsWith("medcaremobile://")) {
              await launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication);
              return NavigationActionPolicy.CANCEL;
            }
            return NavigationActionPolicy.ALLOW;
          }),
    );
  }

  void _handlePaymentAppointment() async {
    String? transcode =
        await Paymentapi.UpdatestatusPayment(paymentID: widget.PaymentID!);
    if (transcode != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PatientFilePage(title: "Lịch khám")));
    }
  }

  void _handlePaymentSuccessISVIP() async {
    if (patientId.isEmpty) return;
    int bookingId = await GetAppointmentApi().createVIPAppointment(
      doctorId: widget.selectedDoctorId ?? 0,
      specialty: widget.selectedSpecialtyName ?? "Không xác định",
      patientProfileId: widget.profileId ?? 0,
      startTime: widget.startTime ?? "",
      endTime: widget.endTime ?? "",
      patientID: patientId[0]['id'],
      worktime: widget.selectDate ?? DateTime.now(),
    );
    if (bookingId == 0) return;
    String? transcode = await Paymentapi.createPayment(
      appointmentid: bookingId,
      TypePayment:
          widget.isNormal == false && widget.isVIP == false ? "MOMO" : "VNPAY",
      amount: 300000,
      isVIP: widget.isVIP ?? false,
      status: "Đã thanh toán",
    );
    if (transcode != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Choosebill(
            bookingId: transcode,
            patientName: widget.patientName ?? "Không xác định",
            paymentTime:
                "${formatDate(widget.selectDate!)} - ${widget.selectTime!}",
            doctorName: "BS. ${widget.Doctorname ?? ""}",
            specialization: widget.selectedSpecialtyName ?? "",
            totalAmount: "300.00 VND",
          ),
        ),
      );
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
          TypePayment: widget.isNormal == false && widget.isVIP == false
              ? "MOMO"
              : "VNPAY",
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

