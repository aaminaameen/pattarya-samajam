// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
//
// const String account = "https://pattarya.besocial.pro/api/v1/getAnyTableDatas?query=SELECT*FROM account";
//
//
//
// List<dynamic> result =[];
//
// class UserRepo{
//   static Future<List> accountData() async {
//     final response = await http.get(Uri.parse(account));
//     if (response.statusCode == 200) {
//       List courses = jsonDecode(response.body)['data'];
//       return courses;
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}


class AuthServiceLogin {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseAuth get auth => _auth;

  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  static Future<UserCredential?> signInWithCredential(
      AuthCredential credential) async {
    try {
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  static void signOut() {
    _auth.signOut();
  }
}
