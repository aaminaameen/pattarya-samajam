import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../payment_confirm/donation_confirm.dart';




class Sambhavana extends StatefulWidget {
  const Sambhavana({Key? key}) : super(key: key);

  @override
  State<Sambhavana> createState() => _SambhavanaState();
}

class _SambhavanaState extends State<Sambhavana> {

  final _razorpay = Razorpay();
  double _amount = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String? uid;
  late String phone;
  TextEditingController amntController = TextEditingController();
  Map? data;
  List<String> dataList = [];
  String phoneNumbers = '';


  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return  KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          width: width * .5,
          height: height * .37,
          child: Padding(
            padding: const EdgeInsets.only(
                left: addPadding * 1.5,
                right: addPadding * 1.5,
                bottom: addPadding * .7,
                top: addPadding * .7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sambhavana',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontSize: 26, fontFamily: 'Inter'),
                ),
                SizedBox(
                  height: height * .08,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: amntController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kWhitColor,
                      hintText: 'amount',
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
                    onChanged: (value) {
                      setState(() {
                        _amount = double.parse(value);
                      });
                    },
                  ),
                ),
                CustomButton(
                    text: 'Confirm Payment',
                    ontap: () {
                      openCheckout();
                    }),
              ],
            ),
          ),
        ),
      );
    }
    );
  }


  void retrievePhoneNumber() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && user.phoneNumber != null) {
      setState(() {
        phoneNumbers = user.phoneNumber!;
      });

      print('Phone number retrieved successfully.');
    } else {
      print('User phone number is not available.');
    }
  }

  @override
  void initState() {
    retrievePhoneNumber();
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    uid = user?.uid;
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }


  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_kixavd4r8zl97U',
      'amount': _amount * 100,
      'name': ' Pattarya Samajam',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Transaction Completed Successfully!',
    );

    Map<String, dynamic> postData = {
      'uid': uid.toString(),
      'amount': amntController.text,
      'phone': phoneNumbers,
      'status': 'success',
    };
    String jsonPostData = json.encode(postData);
    Uri apiUrl = Uri.parse('https://pattarya.besocial.pro/api/v1/addDonation');

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonPostData,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Data posted successfully!',
        );

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PaymentConfirm(
            uid: uid!,
          );
        }));
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Failed!',
          text: 'Failed to post data to server, please try again',
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Failed!',
      text: 'Payment process failed, Try again',
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}




}
