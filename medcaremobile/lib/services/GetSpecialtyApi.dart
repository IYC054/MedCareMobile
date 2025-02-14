import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/IpNetwork.dart';

class Getspecialtyapi {
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/specialty";
  static Future<List<dynamic>> getSpecialtyByDoctorid(int id) async {
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
  static Future<List<dynamic>> getAllSpecialty() async {
    try {
      final url = Uri.parse("$baseUrl");
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