import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/IpNetwork.dart';

class Getprofileapi {
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/patientsprofile";

 

  // Non-static method to get profile by user ID
  Future<List<dynamic>> getProfileByUserid(int id) async {
    try {
      final url = Uri.parse("$baseUrl/account/$id");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes); // Fix encoding
        final List<dynamic> data = jsonDecode(utf8Decoded);
        return data.isNotEmpty ? data : [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error calling API: $e");
      return [];
    }
  }
}
