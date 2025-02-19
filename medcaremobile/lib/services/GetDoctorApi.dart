import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/IpNetwork.dart';

class Getdoctorapi {
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/doctors";

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
