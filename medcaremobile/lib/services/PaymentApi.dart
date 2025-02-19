import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/IpNetwork.dart';
import 'package:medcaremobile/services/StorageService.dart';

class Paymentapi {
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/payments";
    static String? token;

  static Future<void> init() async {
    token = await StorageService.getToken();
  }
  static Future<String?> createPayment(
      {required int appointmentid,
      required int amount,
      required String status,
      required bool isVIP}) async {
    try {
      if (token == null) await init(); 

      final url = Uri.parse('$baseUrl?isVIP=$isVIP');
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "amount": amount,
          "paymentMethod": "VNPAY",
          "status": status,
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
    static Future<String?> UpdatestatusPayment(
      {required int paymentID,
      }) async {
    try {
      if (token == null) await init(); 

      final url = Uri.parse('$baseUrl/status/$paymentID');
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "status": "Đã thanh toán",
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
