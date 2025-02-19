import 'dart:convert';
import 'package:http/http.dart' as http;

class Provinceapi {
  static const String baseUrl = "https://esgoo.net/api-tinhthanh/";

  // Fetch Provinces
  static Future<List<dynamic>> getProvinces() async {
    final response = await http.get(Uri.parse("${baseUrl}1/0.htm"),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      final utf8Decoded = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> data = jsonDecode(utf8Decoded);
      return data['data']; // Assuming the list of provinces is under the 'data' key
    } else {
      throw Exception("Failed to load provinces");
    }
  }

  // Fetch Districts
  static Future<List<dynamic>> getDistricts(int provinceId) async {
    final response = await http.get(Uri.parse("${baseUrl}2/$provinceId.htm"),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      final utf8Decoded = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> data = jsonDecode(utf8Decoded);
      return data['data']; // Assuming the list of districts is under the 'data' key
    } else {
      throw Exception("Failed to load districts");
    }
  }

  // Fetch Wards
  static Future<List<dynamic>> getWards(int districtId) async {
    final response = await http.get(Uri.parse("${baseUrl}3/$districtId.htm"),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      final utf8Decoded = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> data = jsonDecode(utf8Decoded);
      return data['data']; // Assuming the list of wards is under the 'data' key
    } else {
      throw Exception("Failed to load wards");
    }
  }
}
