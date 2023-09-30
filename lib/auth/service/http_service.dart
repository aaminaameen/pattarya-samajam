import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import '../../home/screen/home_screen.dart';
import '../../utils/colors.dart';

class LoginHelper {
  static void verifyNumber(
      String phoneNumber,
      Function(String) onVerificationCompleted,
      Function(FirebaseAuthException) onVerificationFailed,
      Function(String) onCodeSent,
      Function(String) onCodeAutoRetrievalTimeout,
      ) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("logged in successfully");
        });
        onVerificationCompleted(auth.currentUser!.uid);
      },
      verificationFailed: (FirebaseAuthException exception) {
        onVerificationFailed(exception);
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        onCodeAutoRetrievalTimeout(verificationId);
      },
    );
  }

  static Future<void> submitForm(
      String code,
      String value,
      String uid,
      String phoneNumber,
      BuildContext context,
      ) async {
    try {
      UserCredential authResult = await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
        verificationId: code,
        smsCode: value,
      ));
      User? user = authResult.user;
      if (authResult.additionalUserInfo!.isNewUser) {
        await createAccount(uid, phoneNumber, context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              phoneNumber: phoneNumber,
              uid: uid,
            ),
          ),
              (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              phoneNumber: phoneNumber,
              uid: uid,
            ),
          ),
              (route) => false,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<http.Response> createAccount(
      String uid,
      String phoneNumber,
      BuildContext context,
      ) async {
    var response = await http.post(
      Uri.parse('https://pattarya.besocial.pro/api/v1/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': uid,
        'phone': phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Your application form is successfully submitted"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error submitting form'),
        ),
      );
    }
    return response;
  }
}
