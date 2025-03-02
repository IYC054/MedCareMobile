import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirestoreService {
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

      // Thử đăng nhập
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await saveUserToken2(); //  Lưu device token sau khi đăng nhập
      return "✅ Login successfully with Firestore";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("🚀 Email chưa tồn tại, tạo mới...");

        //  Tạo tài khoản mới nếu chưa tồn tại
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await saveUserToken2();
        return "✅ Register and login successfully with Firestore";
      } else if (e.code == 'wrong-password') {
        return "❌ Sai mật khẩu!";
      } else {
        return "❌ FirebaseAuth Error: ${e.message}";
      }
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
