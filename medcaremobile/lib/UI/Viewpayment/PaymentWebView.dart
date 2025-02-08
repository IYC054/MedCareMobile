import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:medcaremobile/UI/Appointment/Doctor/ChooseBill.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  const PaymentWebView({required this.paymentUrl});

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thanh toán VNPAY")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.paymentUrl)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) {
          // Kiểm tra nếu URL là `vnp_ReturnUrl`
          if (url.toString().contains("vnpay-payment-return")) {
            _handlePaymentSuccess(url.toString());
          }
        },
      ),
    );
  }

  void _handlePaymentSuccess(String url) {
    // Điều hướng đến màn hình thành công
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Choosebill(
                bookingId: "32133231",
                patientName: "Nguyễn Văn A",
                paymentTime: "08/02/2025 - 12:30",
                doctorName: "BS. Trần Văn B",
                specialization: "Nội Khoa",
                totalAmount: "1.500.000 VND",
              )),
    );
  }
}
