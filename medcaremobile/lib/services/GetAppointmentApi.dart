import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/GetPatientApi.dart';
import 'package:medcaremobile/services/IpNetwork.dart';
import 'package:medcaremobile/services/StorageService.dart';

class GetAppointmentApi {
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/appointment";
  static const String baseUrlVip = "http://$ip:8080/api/vip-appointments";
  static String? token;
  List<dynamic> patientId = []; // Initialize as an empty list

  // Constructor
  GetAppointmentApi();

  // Async method to load patient data
  Future<void> loadPatientData() async {
    // Wait for the data to be loaded before using it
    patientId = await Getpatientapi.getPatientbyAccountid();
    print("Patient ID loaded: $patientId");
  }

  static Future<void> init() async {
    token = await StorageService.getToken();
  }

  Future<int> createAppointment({
    required int doctorId,
    required String specialty,
    required int worktimeId,
    required int patientProfileId,
  }) async {
    try {
      if (patientId.isEmpty) {
        // Make sure the data is loaded before accessing it
        await loadPatientData();
      }
      if (token == null) await init();
      final url = Uri.parse(baseUrl);
      print(
          "doctoId: ${doctorId} \n specialty: ${specialty} \n patientprofile: ${patientProfileId} \n worktime: ${worktimeId} \n patientID: ${patientId[0]['id']}");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "patientId": patientId[0]['id'],
          "doctorId": doctorId,
          "type": "Khám $specialty",
          "status": "Chờ xử lý",
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

  Future<int> createVIPAppointment({
    required int doctorId,
    required String specialty,
    required DateTime worktime,
    required String startTime,
    required String endTime,
    required int patientProfileId,
  }) async {
   try {
      if (patientId.isEmpty) {
        // Make sure the data is loaded before accessing it
        await loadPatientData();
      }
      if (token == null) await init();
      final url = Uri.parse(baseUrlVip);

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "patientId": patientId[0]['id'],
          "doctorId": doctorId,
          "profileId": patientProfileId,
          "type": "Khám $specialty",
          "workDate": worktime.toIso8601String(),
          "startTime": startTime,
          "endTime": endTime,
          "status": "Đã thanh toán",
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
  static Future<List<dynamic>> fetchVipAppointmentbyPatientId(int id) async {
    try {
      final url = Uri.parse('$baseUrlVip/patient/$id');
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
  static Future<String> GenerateQRApointment(int id, bool isVIP) async {
    try {
      final url =
          Uri.parse('$baseUrl/generate-qrcode?appointmentId=$id&isVIP=$isVIP');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return base64Encode(response.bodyBytes); 
      } else {
        throw Exception("Failed to load QR code");
      }
    } catch (e) {
      print("Lỗi khi gọi API: $e");
      return '';
    }
  }
}
