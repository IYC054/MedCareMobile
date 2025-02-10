import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/IpNetwork.dart';

class Paymentapi {
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/payments";

  static Future<String?> createPayment({required int appointmentid}) async {
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "amount": 100.00,
          "paymentMethod": "VNPAY",
          "status": "Chờ xử lý",
          "appointmentId": appointmentid,
          "transactionDescription": "Thanh toán đặt lịch"
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final utf8Decoded = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> responseData = jsonDecode(utf8Decoded);

        String bookingId = responseData["transactionCode"];
        print("Thanh toán thành công $bookingId");

        return bookingId;
      } else {
        print("❌ Lỗi khi đặt lịch: ${response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Lỗi khi gọi API: $e");
      return null;
    }
  }
}
