import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/models/Account.dart';
import './StorageService.dart';
//173.16.16.52
class AccountAPIService{
  String url = "http://192.168.1.211:8080/api/account";
  // final String token = StorageService.getToken() as String;

  Future<Map<String, dynamic>?> checkLogin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/token"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String? token = data?['result']?['token'] as String?;

        if (token != null) {
          await StorageService.saveToken(token);
          print("Đăng nhập thành công! Token: $token");
        } else {
          print("Lỗi: API không trả về token.");
        }

        return data; // Trả về toàn bộ dữ liệu từ API
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? "Login failed");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }


  Future<bool?> checkEmailExist(String email) async {
    // //lay token
    // final data = await checkLogin(
    //   "admin@gmail.com",
    //   "admin"
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

    // final String? token = await StorageService.getToken();
    // if (token == null) {
    //   throw Exception("Không tìm thấy token, vui lòng đăng nhập lại.");
    // }
    //check email
    try {
      final response = await http.get(
        Uri.parse("$url/find?email=${Uri.encodeComponent(email)}"),
        headers: {
          // "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Lỗi khi kiểm tra email!");
      }

      final decodedResponse = json.decode(response.body);
      if (decodedResponse is bool) {
        return decodedResponse;
      } else {
        throw Exception("Dữ liệu trả về không hợp lệ: $decodedResponse");
      }

    } catch (error) {
      throw Exception("Lỗi kết nối đến server: $error");
    }
  }



}