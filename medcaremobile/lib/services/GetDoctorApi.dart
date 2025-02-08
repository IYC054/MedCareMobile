import 'dart:convert';
import 'package:http/http.dart' as http;

class Getdoctorapi {
  
  static const String baseUrl = "http://192.168.1.22:8080/api/doctors";
  static Future<List<dynamic>> fetchDoctors() async {
    try {
      final url = Uri.parse(baseUrl);
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
