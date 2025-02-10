import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/IpNetwork.dart';

class Getdoctorworking {
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/workinghours";
  static Future<List<dynamic>> fetchDoctorsWorking(int id) async {
    try {
      final url = Uri.parse("$baseUrl/doctor/$id");
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

  static Future<List<dynamic>> fetchDoctorsTime(int id) async {
    try {
      final url = Uri.parse("$baseUrl/$id");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes); // Fix encoding
        final jsonData = jsonDecode(utf8Decoded);

        print("📌 API Response: $jsonData"); // Debug dữ liệu API

        if (jsonData is List) {
          return jsonData;
        } else if (jsonData is Map<String, dynamic>) {
          return [jsonData]; // Chuyển Map thành List nếu cần
        } else {
          return [];
        }
      } else {
        print("⚠️ API Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ Lỗi khi gọi API: $e");
      return [];
    }
  }
}
