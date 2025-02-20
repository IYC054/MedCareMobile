import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/IpNetwork.dart';
import 'package:medcaremobile/services/StorageService.dart';

class Getdoctorapi {
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/doctors";
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
  static Future<Map<String, dynamic>?> getDoctorbyAccountid() async {
  try {
    if (user == null) {
      await loadUserData(); // Load user data nếu chưa có
    }
    final url = Uri.parse("$baseUrl/account/${user?['id']}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final utf8Decoded = utf8.decode(response.bodyBytes); // Fix encoding
      final Map<String, dynamic> data = jsonDecode(utf8Decoded); // Sửa kiểu dữ liệu
      print("BAC SI: $data");
      return data;
    } else {
      return null;
    }
  } catch (e) {
    print("Error calling API: $e");
    return null;
  }
}

  static Future<List<dynamic>> fetchDoctors() async {
    try {
      final url = Uri.parse(baseUrl);
      print("Fetching from: $url"); // Debug URL
      final response = await http.get(url);

      print("Status Code: ${response.statusCode}"); // Debug status code

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes);
        final List<dynamic> data = jsonDecode(utf8Decoded);
        print("Data received: $data"); // Debug data
        return data.isNotEmpty ? data : [];
      } else {
        print("API error: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print("Lỗi khi gọi API: $e");
      return [];
    }
  }
  static Future<List<dynamic>> fetchDoctorsbySpecialty(int id) async {
    try {
      final url = Uri.parse('$baseUrl/specialty/$id');
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
