import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreService {
  static Future saveUserToken(String token) async {
    User? user = FirebaseAuth.instance.currentUser;
    print("Firestore User: $user");
    Map<String, dynamic> data = {
      "email": user!.email,
      "token": token
    };

    try {
      await FirebaseFirestore.instance.collection("user_data").doc(user!.uid).set(data);
      print("Document saved");
    } catch (e) {
      print("FirebaseFirestore error: ${e.toString()}");
    }
  }

  //register save to firestore
  static Future<String> createAccountWithEmail(String email, String password) async {
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
       print("Create account to Firestore successfully");
      return "Create account to Firestore successfully";
    }on FirebaseAuthException catch(e){
      return e.message.toString();
    } catch(e){
      return e.toString();
    }
  }
  //login with email, password method
  static Future<String> loginWithEmail(String email, String password) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      print("Login successfully with Firestore");
      return "Login successfully with Firestore";
    }on FirebaseAuthException catch (e){
      return e.message.toString();
    } catch(e){
      return e.toString();
    }
  }

  static Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  //check the user logged in or not
  static Future<bool> isLoggedIn() async{
    var user = await FirebaseAuth.instance.currentUser;
    return user != null;
  }

  static Future<void> saveNotification(String userId, String title, String body) async {
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