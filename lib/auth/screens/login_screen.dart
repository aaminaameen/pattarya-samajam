import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pattarya_samajam/auth/service/auth_service.dart';
import 'package:pattarya_samajam/utils/constants.dart';
import 'package:pattarya_samajam/home/screen/home_screen.dart';
import 'package:http/http.dart' as http;

import '../../utils/colors.dart';
import '../service/http_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String verify = '';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String? uid;
  String code = '';
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late String verificationId;
  bool _isLoading = false;
  bool _isLoad = false;
  bool mobileverified = false;
  bool otpverified = false;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    uid = user?.uid;
  }



  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlackColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(addPadding / 1),
                child: SizedBox(
                  height: height * .47,
                  width: width * .8,
                  child: Image.asset(
                    'images/god.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                height: height * .44,
                width: width,
                decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(addPadding * 1.2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Text(
                        'SignUp | Login',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontSize: 26),
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      SizedBox(
                        height: height * .08,
                        child: TextFormField(
                          key: _formKey,
                          onChanged: (val) {
                            if (phoneController.text.length == 10) {
                              setState(() {
                                mobileverified = true;
                              });
                            } else {
                              setState(() {
                                mobileverified = false;
                              });
                            }
                          },
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: kWhitColor,
                            hintText: 'Phone no',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                    fontSize: 16,
                                    color: kTextFieldBottom,
                                    fontWeight: FontWeight.w500),
                            suffix: mobileverified
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        verifyNumber();

                                        setState(() {
                                          _isLoading = true;
                                        });
                                        Future.delayed(
                                            const Duration(seconds: 10), () {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      },
                                      child: Container(
                                        width: width * .23,
                                        height: height * .04,
                                        decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                            child: _isLoading
                                                ? SizedBox(
                                                    height: height * .0213,
                                                    width: width * .0432,
                                                    child:
                                                        const CircularProgressIndicator(
                                                      color: kWhitColor,
                                                    ),
                                                  )
                                                : const Text(
                                                    "CONFIRM",
                                                    style: TextStyle(
                                                        color: kWhitColor,
                                                        fontSize: 12),
                                                  )),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      SizedBox(
                        height: height * .1,
                        child: TextFormField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          autofillHints: const [AutofillHints.oneTimeCode],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: kPrimaryLight,
                            hintText: 'Otp',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                    fontSize: 16,
                                    color: kTextFieldBottom,
                                    fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          //  maxLength: 6,
                          onChanged: (val) {
                            if (val.length == 6) {
                              otpController.text = val;
                              _focusNode.nextFocus();
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () async {

                            _submitForm(otpController.text);
                            setState(() {
                              _isLoad = true;
                            });
                            Future.delayed(const Duration(seconds: 9), () {
                              setState(() {
                                _isLoad = false;
                              });
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              color: kBlackColor,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: kBlackColor, width: 2),
                            ),
                            child: Center(
                              child: _isLoad
                                  ? SizedBox(
                                      height: height * .0213,
                                      width: width * .0432,
                                      child: const CircularProgressIndicator(
                                        color: kWhitColor,
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                      'Continue',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(color: kWhitColor),
                                    )),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verifyNumber() {
    AuthServiceLogin.auth.verifyPhoneNumber(
    //auth.verifyPhoneNumber(
      phoneNumber: "+91${phoneController.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException exception) {
        if (exception.code == 'invalid-phone-number') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Invalid Phone Number'),
              content: const Text(
                  'The format of the phone number provided is incorrect.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        }
      },
      codeSent: (String verificationID, int? resendToken) {
        code = verificationID;
      },
      codeAutoRetrievalTimeout: (String verificationID) {},
    );
  }

  void _submitForm(String value) async {
    try {
      UserCredential authResult = await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: code, smsCode: value));
      User? user = auth.currentUser;
      user = FirebaseAuth.instance.currentUser;
      uid = user?.uid;
      if (authResult.additionalUserInfo!.isNewUser) {
        await createAccount();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      phoneNumber: phoneController.text,
                      uid: uid!,
                    )),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      phoneNumber: phoneController.text,
                      uid: uid!,
                    )),
            (route) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response> createAccount() async {
    var response = await http.post(
      Uri.parse('https://pattarya.besocial.pro/api/v1/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': uid!,
        'phone': phoneController.text,
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context)  {
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
