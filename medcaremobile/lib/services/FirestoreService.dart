import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medcaremobile/services/IpNetwork.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FirestoreService {
  static const ip = Ipnetwork.ip;

  String url = "http://$ip:8080/api/account/check-email";
  static Future saveUserToken(String token) async {
    User? user = FirebaseAuth.instance.currentUser;
    print("Firestore User: $user");
    Map<String, dynamic> data = {"email": user!.email, "token": token};

    try {
      await FirebaseFirestore.instance
          .collection("user_data")
          .doc(user!.uid)
          .set(data);
      print("Document saved");
    } catch (e) {
      print("FirebaseFirestore error: ${e.toString()}");
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await http.get(
        Uri.parse("$url?email=$email"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) ==
            true; // Trả về true nếu email tồn tại
      } else {
        print("❌ Lỗi API: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Lỗi: $e");
      return false;
    }
  }

  //register save to firestore
  static Future<String> createAccountWithEmail(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print("Create account to Firestore successfully");
      return "Create account to Firestore successfully";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future<void> saveUserToken2() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("❌ No user logged in");
      return;
    }

    // Lấy Device Token mới
    String? newDeviceToken = await FirebaseMessaging.instance.getToken();
    if (newDeviceToken == null) {
      print("❗ Không lấy được Device Token");
      return;
    }

    print("📌 New Device Token: $newDeviceToken");

    // 🔍 Kiểm tra token cũ trên Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("user_data")
        .doc(user.uid)
        .get();

    String? oldDeviceToken = userDoc.data() != null ? userDoc["token"] : null;

    // 🔄 Chỉ cập nhật nếu token thay đổi
    if (oldDeviceToken != newDeviceToken) {
      Map<String, dynamic> data = {
        "email": user.email,
        "token": newDeviceToken
      };

      try {
        await FirebaseFirestore.instance
            .collection("user_data")
            .doc(user.uid)
            .set(data, SetOptions(merge: true));
        print("✅ Device Token updated!");
      } catch (e) {
        print("❌ FirebaseFirestore error: ${e.toString()}");
      }
    } else {
      print("🔄 Device Token không thay đổi, không cần cập nhật.");
    }
  }

  //login with email, password method
  static Future<String> loginWithEmail(String email, String password) async {
    try {
      FirebaseAuth.instance.setLanguageCode("vi");
      FirestoreService firestoreService = FirestoreService();
      bool emailExists = await firestoreService.checkEmailExists(email);
      if (emailExists) {
        print("✅ Email tồn tại trong Firebase");

        // Đăng nhập
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        await saveUserToken2(); // 🛠 Lưu Device Token sau khi đăng nhập
        return "Login successfully with Firestore";
      } else {
        print("🚀 Email chưa tồn tại, tạo mới...");

        // Đăng ký tài khoản
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await saveUserToken2(); // 🛠 Lưu Device Token sau khi đăng ký
        return "Register and login successfully with Firestore";
      }
    } on FirebaseAuthException catch (e) {
      return "❌ FirebaseAuth Error: ${e.message}";
    } catch (e) {
      return "⚠️ Unexpected Error: $e";
    }
  }

  static Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  //check the user logged in or not
  static Future<bool> isLoggedIn() async {
    var user = await FirebaseAuth.instance.currentUser;
    return user != null;
  }

  static Future<void> saveNotification(
      String userId, String title, String body) async {
    await FirebaseFirestore.instance.collection("notifications").add({
      "userId": userId,
      "title": title,
      "body": body,
      "timestamp": FieldValue.serverTimestamp()
    });
  }

  static Stream<QuerySnapshot> getNotifications(String userId) {
    return FirebaseFirestore.instance
        .collection("notifications")
        .where("userId", isEqualTo: userId)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
