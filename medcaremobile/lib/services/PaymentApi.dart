import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/IpNetwork.dart';

class Paymentapi {
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/payments?isVIP=true";
  static const token =
      "eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJuZ2hpbWF0aGl0LmNvbSIsInN1YiI6Im5naGltYXRoaXRAZXhhbXBsZS5jb20iLCJpZCI6MSwiZXhwIjoxNzM5NDY4NzM1LCJpYXQiOjE3Mzk0MzI3MzUsInNjb3BlIjoiUEFUSUVOVFMgVklFV19QQVRJRU5UIEVESVRfUEFUSUVOVCJ9.JDfiC11WWmV-UL7gIaSDeqgocbrYeitUf7nRGFONQxoPsRQ1bZZ7bJkYgTQa6Whz0GY52y2vok5eE9NI-jxaPw";

  static Future<String?> createPayment(
      {required int appointmentid,
      required int amount,
      required bool isVIP}) async {
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "amount": amount,
          "paymentMethod": "VNPAY",
          "status": "Chờ xử lý",
          isVIP ? "vipAppointmentId" : "appointmentId": appointmentid,
          "transactionDescription": "Thanh toán đặt lịch ${isVIP ? "VIP" : "Thường"}"
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final utf8Decoded = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> responseData = jsonDecode(utf8Decoded);

        String bookingId = responseData["transactionCode"];
        print("Thanh toán thành công $bookingId");

        return bookingId;
      } else {
        print("❌ Lỗi payment: ${response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Lỗi khi gọi API: $e");
      return null;
    }
  }
}
