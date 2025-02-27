import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class CheckCCCDAPI {
  static const String baseUrl = "https://api.fpt.ai/vision/idr/vnm";
  static const String apiKey = "l8vMRpnfmoeRLEyGE3rCmNis4SzSLZal"; 

  static Future<Map<String, dynamic>?> getCCCD(File image) async {
    try {
      final url = Uri.parse(baseUrl);

      var request = http.MultipartRequest('POST', url)
        ..headers['api-key'] = apiKey 
        ..files.add(
          await http.MultipartFile.fromPath(
            'image', 
            image.path,
            filename: basename(image.path),
          ),
        );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(responseBody.codeUnits));
        print("Kết quả API: $data");
        return data;
      } else {
        print("Lỗi API: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi khi gọi API: $e");
      return null;
    }
  }
}
