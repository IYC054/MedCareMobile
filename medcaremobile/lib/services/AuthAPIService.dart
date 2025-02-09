import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/models/Account.dart';
import 'package:medcaremobile/services/AccountAPIService.dart';
import './StorageService.dart';

class AuthAPIService{
  String url = "http://192.168.1.211:8080/api/auth";
  AccountAPIService accountAPIService = AccountAPIService();
  Future<bool> sendOTP(String email) async {
    // //lay token
    // final data = await accountAPIService.checkLogin(
    //     "admin@gmail.com",
    //     "admin"
    // );
    //
    // if (data != null &&
    //     data.containsKey('result') &&
    //     data['result'] != null &&
    //     data['result'].containsKey('token') &&
    //     data['result']['token'] != null) {
    //   final String token = data['result']['token'] as String;
    //
    //   // Lưu token vào SharedPreferences
    //   await StorageService.saveToken(token);
    // }
    //
    // final String? token = await StorageService.getToken();
    // if (token == null) {
    //   throw Exception("Không tìm thấy token, vui lòng đăng nhập lại.");
    // }

    try {
      final response = await http.post(
        Uri.parse("$url/send?email=$email"), // 🟢 Giữ nguyên @RequestParam
        headers: {
          // "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception("Lỗi từ server: ${responseBody['message']}");
      }
    } catch (e) {
      print("Lỗi gửi OTP: $e");
      throw Exception("Lỗi gửi OTP: $e");
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$url/verify?email=$email&otp=$otp'),
        headers: {'Content-Type': 'application/json'},
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Xác thực OTP thất bại!");
      }
    } catch (e) {
      print("Lỗi kết nối: $e");
      throw Exception("Không thể kết nối đến server!");
    }
  }
}