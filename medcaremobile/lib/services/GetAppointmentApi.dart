import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/GetPatientApi.dart';
import 'package:medcaremobile/services/IpNetwork.dart';
import 'package:medcaremobile/services/StorageService.dart';
import 'package:intl/intl.dart';

class GetAppointmentApi {
  GetAppointmentApi();
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/appointment";
  static const String baseUrlVip = "http://$ip:8080/api/vip-appointments";
  static String? token;
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

  static Future<void> init() async {
    token = await StorageService.getToken();
  }

  Future<int> createAppointment({
    required int doctorId,
    required String specialty,
    required int worktimeId,
    required int patientProfileId,
    required int patientID,
    required String doctorEmail,
  }) async {
    try {
      if (patientId.isEmpty) {
        // Make sure the data is loaded before accessing it
        await loadPatientData();
      }
      if (token == null) await init();
      //lấy uid từ firebase
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("⚠️ Không có user đăng nhập! Hủy gọi API.");
        return 0;
      }
      String userIdFirestore = user.uid;
      print("User ID Firestore: " + userIdFirestore);
      final url = Uri.parse(baseUrl);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "patientId": patientID,
          "doctorId": doctorId,
          "type": specialty,
          "status": "Chờ xử lý",
          "amount": 150000.0,
          "worktimeId": worktimeId,
          "patientProfileId": patientProfileId,
          "firestoreUserId": userIdFirestore,
          "doctorEmail": doctorEmail
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
      print("⚠️ Lỗi khi gọi API apointment: $e");
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
    required int patientID,
    required String doctorEmail,
  }) async {
    try {
      if (patientId.isEmpty) {
        // Make sure the data is loaded before accessing it
        await loadPatientData();
      }
      if (token == null) await init();
      //lấy uid từ firebase
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("⚠️ Không có user đăng nhập! Hủy gọi API.");
        return 0;
      }
      String userIdFirestore = user.uid;
      print("User ID Firestore: " + userIdFirestore);

      final url = Uri.parse(baseUrlVip);

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "patientId": patientID,
          "doctorId": doctorId,
          "profileId": patientProfileId,
          "type": specialty,
          "workDate": worktime.toIso8601String(),
          "startTime": startTime,
          "endTime": endTime,
          "status": "Chờ xử lý",
          "amount": 300000,
          "firestoreUserId": userIdFirestore,
          "doctorEmail": doctorEmail,
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
      print("⚠️ Lỗi khi gọi API appointmentVIP: $e");
      return 0;
    }
  }

  static Future<bool> UpdateVIPAppointment({
    required DateTime worktime,
    required String startTime,
    required String endTime,
    required int appointmentVIPID,
  }) async {
    try {
      final url = Uri.parse("$baseUrlVip/$appointmentVIPID/update-time");
      final formattedDate = DateFormat("yyyy-MM-dd").format(worktime);

      print("📢 URL: $url");
      print(
          "📢 Request Body: { workDate: $formattedDate, startTime: $startTime, endTime: $endTime }");

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "workDate": formattedDate,
          "startTime": startTime,
          "endTime": endTime,
        }),
      );

      print("📢 Response Status: ${response.statusCode}");
      print("📢 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          try {
            final utf8Decoded = utf8.decode(response.bodyBytes);
            final Map<String, dynamic> responseData = jsonDecode(utf8Decoded);
            print("✅ responseData: $responseData");
            return true;
          } catch (e) {
            print("⚠️ Lỗi JSON Decode nhưng vẫn trả về true: $e");
            return true;
          }
        } else {
          print("✅ API không trả về dữ liệu, nhưng cập nhật thành công.");
          return true;
        }
      } else {
        print("❌ Lỗi cập nhật: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e, stacktrace) {
      print("⚠️ Lỗi khi gọi API UpdateVIPAppointment: $e");
      print("🛑 Stacktrace: $stacktrace");
      return false;
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
      print("Lỗi khi gọi API fetchVIP: $e");
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
      print("Lỗi khi gọi API fectchVIPBYPATIENT: $e");
      return [];
    }
  }

  static Future<List<dynamic>> fetchVipAppointmentbyDoctorId(int id) async {
    try {
      final url = Uri.parse('$baseUrlVip/doctors/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes); // Fix encoding
        final List<dynamic> data = jsonDecode(utf8Decoded);
        return data.isNotEmpty ? data : [];
      } else {
        return [];
      }
    } catch (e) {
      print("Lỗi khi gọi API fetchVIPBYDOCTOR: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>?> GetVipAppointmentbyId(int id) async {
    try {
      final url = Uri.parse('$baseUrlVip/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes); // Fix encoding
        final Map<String, dynamic> data = jsonDecode(utf8Decoded);
        return data.isNotEmpty ? data : null;
      } else {
        print("Lỗi API: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi khi gọi API GetVIPBYDOCTOR: $e");
      return null;
    }
  }

  // ignore: non_constant_identifier_names
  static Future<bool> UpdateStatusAppointment(int id) async {
    try {
      final url = Uri.parse('$baseUrl/status/$id');
      final response = await http.put(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"status": "Đã huỷ"}));

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes); // Fix encoding
        final Map<String, dynamic> data = jsonDecode(utf8Decoded);
        return true;
      } else {
        print("Lỗi API: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Lỗi khi gọi API GetVIPBYDOCTOR: $e");
      return false;
    }
  }

  static Future<bool> UpdateStatusVIPAppointment(int id) async {
    try {
      final url = Uri.parse('$baseUrlVip/status/$id');
      final response = await http.put(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"status": "Đã huỷ"}));

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes); // Fix encoding
        final Map<String, dynamic> data = jsonDecode(utf8Decoded);
        return true;
      } else {
        print("Lỗi API: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Lỗi khi gọi API GetVIPBYDOCTOR: $e");
      return false;
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
      print("Lỗi khi gọi API QRCODE: $e");
      return '';
    }
  }
}
