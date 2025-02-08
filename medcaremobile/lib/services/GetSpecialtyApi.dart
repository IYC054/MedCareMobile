import 'dart:convert';
import 'package:http/http.dart' as http;

class Getspecialtyapi {
  static const String baseUrl = "http://192.168.1.22:8080/api/specialty";
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
}