import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/IpNetwork.dart';

class GetAppointmentApi {
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/appointment";

  static Future<int> createAppointment({
    required int patientId,
    required int doctorId,
    required String specialty,
    required int worktimeId,
    required int patientProfileId,
  }) async {
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "patientId": patientId,
          "doctorId": doctorId,
          "type": "Khám $specialty",
          "status": "Pending",
          "amount": 150000.0,
          "worktimeId": worktimeId,
          "patientProfileId": patientProfileId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final utf8Decoded = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> responseData = jsonDecode(utf8Decoded);
        
        int bookingId = responseData["id"]; // Lấy bookingId từ API
        print("✅ Đặt lịch thành công! Booking ID: $bookingId");
        
        return bookingId;
      } else {
        print("❌ Lỗi khi đặt lịch: ${response.body}");
        return 0;
      }
    } catch (e) {
      print("⚠️ Lỗi khi gọi API: $e");
      return 0;
    }
  }
}
