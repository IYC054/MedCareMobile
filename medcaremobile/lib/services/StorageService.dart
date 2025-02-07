import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = "auth_token";

  // Lưu token vào SharedPreferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Lấy token từ SharedPreferences (trả về null nếu không có)
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
    await prefs.remove(_tokenKey);
  }
}
