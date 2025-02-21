import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/UI/Appointment/Doctor/CreatePatientInformation.dart';
import 'package:medcaremobile/services/GetPatientApi.dart';
import 'package:medcaremobile/services/StorageService.dart';
import 'IpNetwork.dart';

class Patientinformation {
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/patientsprofile";
  static Map<String, dynamic>? user;
  static String? tokens;

  // Method to load user data asynchronously
  static Future<void> loadToken() async {
    tokens = await StorageService.getToken();
    if (tokens != null) {
      print("Lay tokens Data: $tokens");
    } else {
      print("No user data found. $tokens");
    }
  }

  // Method to load user data asynchronously
  static Future<void> loadUserData() async {
    user = await StorageService.getUser();
    if (user != null) {
      print("Lay user Data: $user['id']");
    } else {
      print("No Patient data found.");
    }
  }

  static Future<int> createPatientInformation({
    required String fullname,
    required String birthdate,
    required String phone,
    required String gender,
    required String codeBhyt,
    required String nation,
    required String address,
  }) async {
    try {
      if (user == null) {
        await loadUserData(); // Wait for user data to be loaded
      }
      if (tokens == null) {
        await loadToken(); // Wait for user data to be loaded
      }
      final url = Uri.parse(baseUrl);
      print("Lay user Datasssss: ${user?['id']}");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $tokens",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "fullname": fullname,
          "birthdate": birthdate,
          "phone": phone,
          "gender": gender,
          "identification_card": codeBhyt,
          "nation": nation,
          "address": address,
          "accountid": user?['id']
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final utf8Decoded = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> responseData = jsonDecode(utf8Decoded);

        int bookingId = responseData["id"];
        print("✅ Tạo hồ sơ thành công");

        return bookingId;
      } else {
        print("❌ Lỗi khi tạo hồ sơ: ${response.body}");
        return 0;
      }
    } catch (e) {
      print("⚠️ Lỗi khi gọi API: $e");
      return 0;
    }
  }
}
