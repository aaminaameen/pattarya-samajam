import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../payment_confirm/kudishika_confirm.dart';
import '../widgets/alert_box.dart';

class KudishikaTotalDue extends StatefulWidget {
  const KudishikaTotalDue({Key? key,}) : super(key: key);


  @override
  State<KudishikaTotalDue> createState() => _KudishikaTotalDueState();
}

class _KudishikaTotalDueState extends State<KudishikaTotalDue> {
  TextEditingController amntController = TextEditingController(text: '0');
  int masavariDue = 0;
  int kudumbaSahayamDue = 0;
  int ulsavaVihitamDue = 0;
  int specialDonationDue = 0;
  final _razorpay = Razorpay();
  double amount = 0;
  String _amount = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String? uid;
  Map? data;
  double ?totalpayamount ;


  Map<String, dynamic> selectedDues = {
    'masavari_due': 0,
    'kudumba_sahayam_due': 0,
    'ulsava_vihitam_due': 0,
    'special_donation_due': 0,
  };

  Map<String , bool> dueType = {
  'masavari_due' : false,
  'kudumba_sahayam_due' :false,
  'ulsava_vihitam_due' : false,
  'special_donation_due' : false
  };

  void fetchData() async {

      final Uri apiUrl = Uri.parse('https://pattarya.besocial.pro/api/v1/getTableDatas?table=kudishika&where=uid&value=$uid');
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        data = jsonData['data'][0];

      } else {

      print('Failed to fetch data. Error code: ${response.statusCode}');
    }
  }



void calculateTotal(String kudishikaType, bool isInclude){
    int total = int.parse(amntController.text);
    int selectedDue = int.parse('${data?[kudishikaType]}');

    if (isInclude) {
      total = total + selectedDue;
      selectedDues[kudishikaType] = selectedDue;
    } else {
      total = total - selectedDue;
      selectedDues[kudishikaType] = 0;
    }
    setState(() {
      amntController.text = total.toString();
      totalpayamount = double.parse(amntController.text);
    });

}


  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom),
            child: Container(
              width: width * .5,
              height: height * .6,
              child: Padding(
                padding: const EdgeInsets.only(left: addPadding * 1.5,
                    right: addPadding * 1.5,
                    bottom: addPadding * .7,
                    top: addPadding * .8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Total Kudishika\n',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 20),
                          children: [
                            TextSpan(
                              text: '(Total Dues)',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          KudishikaCheckBox(
                            onChanged: (bool? value) {
                              setState(() {
                                dueType['masavari_due'] = value!;
                                calculateTotal('masavari_due', value);
                              });
                            },
                            value: dueType['masavari_due'],),
                          Text(
                            'Monthly Contribution',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: kBlackColor),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          KudishikaCheckBox(
                            onChanged: (bool? value) {
                              setState(() {
                                dueType['kudumba_sahayam_due'] = value!;
                                calculateTotal('kudumba_sahayam_due', value);
                              });
                            },
                            value: dueType['kudumba_sahayam_due'],),
                          Text(
                            'Welfare Contribution',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: kBlackColor),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          KudishikaCheckBox(
                            onChanged: (bool? value) {
                              setState(() {
                                dueType['ulsava_vihitam_due'] = value!;
                                calculateTotal('ulsava_vihitam_due', value);
                              });
                            },
                            value: dueType['ulsava_vihitam_due'],),
                          Text(
                            'Festival Share',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: kBlackColor),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          KudishikaCheckBox(
                            onChanged: (bool? value) {
                              setState(() {
                                dueType['special_donation_due'] = value!;
                                calculateTotal('special_donation_due', value);
                              });
                            },
                            value: dueType['special_donation_due'],),
                          Text(
                            'Special Donation', // Title or label for the checkbox
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: kBlackColor),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.02,),
                      SizedBox(
                        height: height * .08,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: amntController,
                           readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: kWhitColor,
                            hintText: 'amount',
                            hintStyle: Theme
                                .of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(fontSize: 16,
                                color: kTextFieldBottom,
                                fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                             amount = double.parse(amntController.text);
                            });
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.02,),
                      CustomButton(text: 'Confirm Payment', ontap: () {
                        openCheckout(totalpayamount);
                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
        } );
  }
  @override
  void initState() {
    super.initState();
      user = FirebaseAuth.instance.currentUser;
      uid = user?.uid;
    fetchData();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  void openCheckout(amount) async {
    var options = {
      'key': 'rzp_live_kixavd4r8zl97U',
      'amount': amount*100,
      'name': ' Pattarya Samajam',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': '8888888888',
        'email': 'test@razorpay.com'
      }
    };
    try {
      _razorpay.open(options);

    } catch (e) {
      print('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Transaction Completed Successfully!',
    );
    List type_selected = [];
    dueType.forEach((key, value) {
      if (value == true){
        type_selected.add(key);
      }

    });

    Map<String, dynamic> postData = {
      'uid': uid.toString(),
      'type_selected': type_selected.join(","),
      'totalAmount' : amntController.text,
    };
    String jsonPostData = json.encode(postData);
    Uri apiUrl = Uri.parse('https://pattarya.besocial.pro/api/v1/payKudishika');

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonPostData,
      );
      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return  KudishikaConfirm(kudishika: amntController.text, uid: uid!,);
        }));
      }
    } catch (e) {
      debugPrint('Error: $e');
    }

  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Failed!',
      text: 'Payment process failed, Try again',
    );
  }


  void _handleExternalWallet(ExternalWalletResponse response) {
  }

}



