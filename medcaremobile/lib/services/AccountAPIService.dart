import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/models/Account.dart';
//173.16.16.52
class AccountAPIService{
  String url = "http://173.16.16.52:8080/api/account";

  Future<Map<String, dynamic>?> checkLogin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/token"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? "Login failed");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}