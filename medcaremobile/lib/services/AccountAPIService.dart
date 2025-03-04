import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:medcaremobile/models/Account.dart';
import './StorageService.dart';
import 'IpNetwork.dart';

//173.16.16.52
class AccountAPIService {
  static const ip = Ipnetwork.ip;
  String url = "http://$ip:8080/api/account";
  // final String token = StorageService.getToken() as String;
  static String? token;
  static Future<void> init() async {
    token = await StorageService.getToken();
  }

  Future<Map<String, dynamic>?> checkLogin(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$url/token"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes); // Fix encoding
        final data = jsonDecode(utf8Decoded);
        final String? token = data['result']?['token'] as String?;

        final Map<String, dynamic>? user = data['result']?['user'];

        if (token != null) {
          await StorageService.saveToken(token);
          print("Đăng nhập thành công! Token: $token");
        } else {
          print("Lỗi: API không trả về token.");
        }

        if (user != null) {
          await StorageService.saveUser(user);
          print("Đăng nhập thành công! User: $user");
        } else {
          print("Lỗi: API không trả về user.");
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
  // Future<Map<String, dynamic>> registerAccount({
  //   required String email,
  //   required String name,
  //   required String password,
  //   required String phone,
  //   required String gender,
  //   required String birthdate,
  //   required List<String> roles,
  //   File? avatar, // Avatar có thể null
  // }) async {
  //   try {
  //     var uri = Uri.parse("$url/register");
  //     var request = http.MultipartRequest("POST", uri);
  //
  //     // Thêm dữ liệu vào request
  //     request.fields["email"] = email;
  //     request.fields["name"] = name;
  //     request.fields["password"] = password;
  //     request.fields["phone"] = phone;
  //     request.fields["gender"] = gender;
  //     request.fields["birthdate"] = birthdate;
  //
  //     // Chuyển danh sách roles thành chuỗi
  //     for (var role in roles) {
  //       request.fields["role"] = role;
  //     }
  //
  //     // Nếu có ảnh đại diện, thêm vào request
  //     if (avatar != null) {
  //       var imageStream = http.ByteStream(avatar.openRead());
  //       var length = await avatar.length();
  //       var multipartFile = http.MultipartFile(
  //         'avatar',
  //         imageStream,
  //         length,
  //         filename: basename(avatar.path),
  //       );
  //       request.files.add(multipartFile);
  //     }
  //
  //     // Gửi request
  //     var response = await request.send();
  //
  //     // Xử lý phản hồi
  //     if (response.statusCode == 200) {
  //       var responseBody = await response.stream.bytesToString();
  //       return json.decode(responseBody);
  //     } else {
  //       return {"error": "Failed with status code ${response.statusCode}"};
  //     }
  //   } catch (e) {
  //     return {"error": e.toString()};
  //   }
  // }

  Future<Map<String, dynamic>> registerAccount({
    required String email,
    required String name,
    required String password,
    required String phone,
    required String gender,
    required String birthdate,
    File? avatar, // Avatar có thể null
  }) async {
    try {
      var uri = Uri.parse("$url");
      var request = http.MultipartRequest("POST", uri);

      // Thêm dữ liệu vào request
      request.fields["email"] = email;
      request.fields["name"] = name;
      request.fields["password"] = password;
      request.fields["phone"] = phone;
      request.fields["gender"] = gender;
      request.fields["birthdate"] = birthdate;

      // Chuyển danh sách roles thành chuỗi
      request.fields["role"] = "PATIENTS";
      // Nếu có ảnh đại diện, thêm vào request
      if (avatar != null) {
        var imageStream = http.ByteStream(avatar.openRead());
        var length = await avatar.length();
        var multipartFile = http.MultipartFile(
          'avatar',
          imageStream,
          length,
          filename: basename(avatar.path),
        );
        request.files.add(multipartFile);
      }

      // Gửi request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print("API Response: $responseBody"); // Debug

      // Xử lý phản hồi
      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        return {"error": "Failed with status code ${response.statusCode}"};
      }
    } catch (e) {
      return {"error": e.toString()};
    }
  }

  Future<bool?> checkEmailExist(String email) async {
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

  Future<Map<String, dynamic>> EditAccount({
    required String email,
    required String name,
    required String phone,
    required String gender,
    required String birthdate,
    required int id,
  }) async {
    try {
      print("=== DỮ LIỆU GỬI LÊN API ===");

      var uri = Uri.parse("$url/$id");

      var request = http.MultipartRequest("PUT", uri);

      // Thêm headers
      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      });

      // Thêm các trường dữ liệu
      request.fields['email'] = email;
      request.fields['name'] = name;
      request.fields['phone'] = phone;
      request.fields['gender'] = gender;
      request.fields['birthdate'] = birthdate;

      // Gửi request
      var response = await request.send();

      // Đọc response
      var responseBody = await response.stream.bytesToString();
      var responseJson = jsonDecode(responseBody);

      print("API Response: $responseJson");

      if (response.statusCode == 200) {
        return responseJson;
      } else {
        return {"error": "Failed with status code ${response.statusCode}"};
      }
    } catch (e) {
      return {"error": e.toString()};
    }
  }
}
