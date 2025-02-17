import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _tokenKey = "auth_token";
  static const String _userKey = "user_data";

  // Lưu token vào SharedPreferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Lưu thông tin user vào SharedPreferences
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = jsonEncode(user); // Chuyển đổi thành chuỗi JSON
    await prefs.setString(_userKey, userDataString);
  }

  // Lấy thông tin user từ SharedPreferences
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  } // Lấy token từ SharedPreferences (trả về null nếu không có)

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Lấy token nhưng trả về chuỗi rỗng nếu null
  static Future<String> getTokenSafe() async {
    final token = await getToken();
    return token ?? ""; // Cung cấp giá trị mặc định tránh lỗi null
  }

  // Xóa token (đăng xuất)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }
}
