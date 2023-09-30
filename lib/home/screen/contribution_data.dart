import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pattarya_samajam/home/screen/home_screen.dart';
import 'package:pattarya_samajam/home/payment_confirm/welfare_confirm.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../payment_confirm/monthly_confirm.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'kudishika_data.dart';

enum Donation {
  masavari_due,
  kudumba_sahayam_due,
  ulsava_vihitam_due,
  special_donation_due
}

class ContributionData {
  final String monthlyContribution;
  final String welfareContribution;

  ContributionData(
      {required this.monthlyContribution, required this.welfareContribution});
}

class ShowDataAlert {
  String uid;

  ShowDataAlert({required this.uid});
  TextEditingController monthlyController = TextEditingController();
  TextEditingController welfareController = TextEditingController();
  TextEditingController festivalController = TextEditingController();
  TextEditingController specialController = TextEditingController();

  Future<void> showAlert(BuildContext ctx, String title, String body) async {
    final double height = MediaQuery.of(ctx).size.height;

    final Uri apiUrl = Uri.parse(
        'https://pattarya.besocial.pro/api/v1/getTableDatas?table=kudishika&where=uid&value=$uid');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      var data = jsonData['data'][0];
      String monthlyContribution = data['masavari_due'].toString();
      String welfareContribution = data['kudumba_sahayam_due'].toString();
      String festivalShare = data['ulsava_vihitam_due'].toString();
      String specialDonation = data['special_donation_due'].toString();

      monthlyController.text = monthlyContribution;
      welfareController.text = welfareContribution;
      festivalController.text = festivalShare;
      specialController.text = specialDonation;
    }

    final action = await showDialog(
        context: ctx,
        builder: (ctx) {
          return KeyboardVisibilityBuilder(
              builder: (context, isKeyboardVisible) {
            return AlertDialog(
              backgroundColor: kBlackColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: isKeyboardVisible
                      ? MediaQuery.of(context).viewInsets.bottom
                      : 2,
                ),
                child: SizedBox(
                  height: height * .61,
                  child: Column(
                    children: [
                      Contribution(
                        mainText: 'Monthly Contribution\n',
                        subText: '(Masavari)',
                        bottomHead: 'Monthly Contribution\n',
                        bottomText: '(Masavari)',
                        controller: monthlyController,
                        dueType: Donation.masavari_due,
                        masavariDue: monthlyController.text,
                        readOnly: false,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Contribution(
                        mainText: 'Welfare Contribution\n',
                        subText: '(Kudumba Sahayam)',
                        bottomHead: 'Welfare Contribution\n',
                        bottomText: 'Kudumba Sahayam',
                        controller: welfareController,
                        dueType: Donation.kudumba_sahayam_due,
                        welfareDue: welfareController.text,
                        readOnly: false,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Contribution(
                        mainText: 'Festival Share\n',
                        subText: '(Ulsava Vihitam)',
                        bottomHead: 'Festival Share\n',
                        bottomText: 'Ulsava vihitam',
                        controller: festivalController,
                        dueType: Donation.ulsava_vihitam_due,
                        readOnly: true,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Contribution(
                        mainText: 'Special Donation\n',
                        subText: '(Chembu Pakal Vihitam)',
                        bottomHead: 'Special Donation\n',
                        bottomText: 'Chembu Pakal Vihitam',
                        controller: specialController,
                        dueType: Donation.special_donation_due,
                        readOnly: true,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Kudishika(height: height),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}

class Contribution extends StatefulWidget {
  const Contribution(
      {Key? key,
      required this.mainText,
      required this.subText,
      required this.bottomHead,
      required this.bottomText,
      this.controller,
      required this.dueType,
      this.masavariDue,
      this.welfareDue,
      required this.readOnly})
      : super(key: key);

  final String mainText;
  final String subText;
  final String bottomHead;
  final String bottomText;
  final TextEditingController? controller;
  final Donation dueType;
  final String? masavariDue;
  final String? welfareDue;
  final bool readOnly;

  @override
  State<Contribution> createState() => _ContributionState();
}

class _ContributionState extends State<Contribution> {
  final _razorpay = Razorpay();
  double amount = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String? uid;
  double? totalpayamount;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          elevation: 10,
          isScrollControlled: true,
          backgroundColor: kPrimaryColor,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          builder: (ctx) =>
              KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                width: width * .5,
                height: height * .35,
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
                      RichText(
                        text: TextSpan(
                          text: widget.bottomHead,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 18),
                          children: [
                            TextSpan(
                              text: widget.bottomText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * .08,
                        child: TextFormField(
                          controller: widget.controller,
                          readOnly: widget.readOnly,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: kWhitColor,
                            hintText: 'amount',
                            hintStyle: Theme.of(ctx)
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
                              amount = double.parse(widget.controller!.text);
                            });
                          },
                        ),
                      ),
                      CustomButton(
                          text: 'Confirm Payment',
                          ontap: () {
                            openCheckout(totalpayamount);
                          }),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
      child: SizedBox(
        height: height * .107,
        child: Stack(
          children: [
            Image.asset(
              'images/3.png',
              height: height * .12,
              fit: BoxFit.fill,
            ),
            Positioned(
              top: 20,
              left: 25,
              child: RichText(
                text: TextSpan(
                  text: widget.mainText,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 14),
                  children: [
                    TextSpan(
                      text: widget.subText,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
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

  void openCheckout(amount) async {
    setState(() {
      totalpayamount = double.parse(widget.controller?.text ?? "0");
    });
    var options = {
      'key': 'rzp_live_kixavd4r8zl97U',
      'amount': amount * 100,
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
      'type_selected': widget.dueType.name,
      'totalAmount': widget.controller?.text ?? '',
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
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Data posted successfully!',
        );

        if (widget.dueType == Donation.masavari_due) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MonthlyConfirm(
              monthlyContribution: widget.masavariDue ?? '',
              uid: uid!,
            );
          }));
        } else if (widget.dueType == Donation.kudumba_sahayam_due) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return WelfareConfirm(
              welfareContribution: widget.welfareDue ?? '',
              uid: uid!,
            );
          }));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HomeScreen(
              phoneNumber: '',
              uid: '',
            );
          }));
        }
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

  void _handlePaymentError(PaymentFailureResponse response) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Failed!',
      text: 'Payment process failed, Try again',
    );
    Map<String, dynamic> postData = {
      'uid': uid.toString(),
      'amount': widget.controller,
      'status': 'failed'
    };
    String jsonPostData = json.encode(postData);
    Uri apiUrl =
        Uri.parse('https://pattarya.besocial.pro/api/v1/paymentUpload');

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonPostData,
      );
      if (response.statusCode == 200) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Data posted successfully!',
        );
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

  void _handleExternalWallet(ExternalWalletResponse response) {}
}
