import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/models/Account.dart';
import 'package:medcaremobile/services/AccountAPIService.dart';
import './StorageService.dart';
import 'IpNetwork.dart';

class AuthAPIService{
  static const ip = Ipnetwork.ip;
  String url = "http://$ip:8080/api/auth";
  AccountAPIService accountAPIService = AccountAPIService();
  Future<bool> sendOTP(String email) async {
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

  Future<Map<String, dynamic>> resetPassword(String email, String newPassword) async {

    try {
      final response = await http.post(
        Uri.parse('$url/reset-password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "newPassword": newPassword,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "message": "Password has been reset successfully."};
      } else {
        // Nếu API trả về lỗi, parse message từ response body
        final responseBody = jsonDecode(response.body);
        return {
          "success": false,
          "message": responseBody["message"] ?? "Failed to reset password."
        };
      }
    } catch (e) {
      return {"success": false, "message": "Server error. Please try again later."};
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$url/forgot-password?email=$email'),
        headers: {'Content-Type': 'application/json'},
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


}
