import 'package:medcaremobile/services/IpNetwork.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/StorageService.dart';

class Getpatientapi {
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/patients";
  
  static Map<String, dynamic>? user;

  // Method to load user data asynchronously
  static Future<void> loadUserData() async {
    user = await StorageService.getUser();
    if (user != null) {
      print("User Data: $user");
    } else {
      print("No user data found.");
    }
  }

  static Future<List<dynamic>> getPatientbyAccountid() async {
    try {
      // Ensure user data is loaded before making the request
      if (user == null) {
        await loadUserData(); // Wait for user data to be loaded
      }

      final url = Uri.parse("$baseUrl/account/${user?['id']}");
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
