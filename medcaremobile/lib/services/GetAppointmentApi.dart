import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/IpNetwork.dart';
import 'package:medcaremobile/services/StorageService.dart';

class GetAppointmentApi {
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/appointment";
  static const String baseUrlVip = "http://$ip:8080/api/vip-appointments";
  static String? token;

  static Future<void> init() async {
    token = await StorageService.getToken();
  }

  static Future<int> createAppointment({
    required int patientId,
    required int doctorId,
    required String specialty,
    required int worktimeId,
    required int patientProfileId,
  }) async {
    try {
      if (token == null) await init(); 
      final url = Uri.parse(baseUrl);
      print(
          "doctoId: ${doctorId} \n specialty: ${specialty} \n patientprofile: ${patientProfileId} \n worktime: ${worktimeId} \n patientID: ${patientId}");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
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

  static Future<int> createVIPAppointment({
    required int patientId,
    required int doctorId,
    required String specialty,
    required DateTime worktime,
    required String startTime,
    required String endTime,
    required int patientProfileId,
  }) async {
    try {
      if (token == null) await init(); 
      final url = Uri.parse(baseUrlVip);
      print(
          "doctoId: ${doctorId} \n specialty: ${specialty} \n patientprofile: ${patientProfileId} \n starttime: ${startTime} \n endtine: ${endTime} \n worktime: ${worktime.toIso8601String()} \n patientID: ${patientId}");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "patientId": patientId,
          "doctorId": doctorId,
          "profileId": patientProfileId,
          "type": "Khám $specialty",
          "workDate": worktime.toIso8601String(),
          "startTime": startTime,
          "endTime": endTime,
          "status": "Chờ xử lý",
          "amount": 300000
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final utf8Decoded = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> responseData = jsonDecode(utf8Decoded);

        int bookingId = responseData["id"];
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

  static Future<List<dynamic>> fetchVipAppointment() async {
    try {
      final url = Uri.parse(baseUrlVip);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes); // Fix encoding
        final List<dynamic> data = jsonDecode(utf8Decoded);
        return data.isNotEmpty ? data : [];
      } else {
        return [];
      }
    } catch (e) {
      print("Lỗi khi gọi API: $e");
      return [];
    }
  }
}
