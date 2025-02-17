import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medcaremobile/services/GetPatientApi.dart';
import 'package:medcaremobile/services/IpNetwork.dart';

class Getprofileapi {
  static const ip = Ipnetwork.ip;
  static const String baseUrl = "http://$ip:8080/api/patientsprofile";

  List<dynamic> patientId = [];  // Initialize as an empty list

  // Constructor
  Getprofileapi();

  // Async method to load patient data
  Future<void> loadPatientData() async {
    // Wait for the data to be loaded before using it
    patientId = await Getpatientapi.getPatientbyAccountid();
    print("Patient ID loaded: $patientId");
  }

  // Non-static method to get profile by user ID
  Future<List<dynamic>> getProfileByUserid() async {
    if (patientId.isEmpty) {
      // Make sure the data is loaded before accessing it
      await loadPatientData();
    }

    if (patientId.isNotEmpty) {
      try {
        final url = Uri.parse("$baseUrl/account/${patientId[0]['id']}");
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
    } else {
      print("No patient data available");
      return [];
    }
  }
}
