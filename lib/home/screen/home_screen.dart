import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pattarya_samajam/auth/screens/login_screen.dart';
import 'package:pattarya_samajam/utils/constants.dart';
import 'package:pattarya_samajam/home/account/account_details.dart';
import 'package:pattarya_samajam/home/screen/sambhavana.dart';
import 'package:http/http.dart' as http;
import '../../utils/colors.dart';
import '../service/list_Items.dart';
import '../widgets/model_class.dart';
import 'contribution_data.dart';
import '../service/logout.dart';
import '../notice/notice_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.phoneNumber,
    required this.uid,
  }) : super(key: key);
  final String phoneNumber;
  final String uid;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String? uid;
  late String phone;
  Map? data;
  int totalAmount = 0;
  int paidAmount = 0;
  int paidAmount1 = 0;
  int paidAmount2 = 0;
  String monthName = '';
  String date = '';
  List<String> masavariDueList = List.filled(3, '');
  List<String> donationList = List.filled(3, '');
  List<String> monthNameList = List.filled(3, '');
  List<String> dateList = List.filled(3, '');
  List<String> dataList = [];
  String title = 'AlertDialog';
  bool tappedYes = false;
  List<Map<String, dynamic>> transactions = [];

  void fetchTotalAmount() async {
    final Uri apiUrl = Uri.parse(
        'https://pattarya.besocial.pro/api/v1/getTableDatas?table=kudishika&where=uid&value=${widget.uid}');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      data = jsonData['data'][0];
      setState(() {
        totalAmount = data?['masavari_due'] +
            data?['kudumba_sahayam_due'] +
            data?['ulsava_vihitam_due'] +
            data?['special_donation_due'];
      });
    } else {
      print('Failed to fetch data. Error code: ${response.statusCode}');
    }
  }


  String formatDate(String timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
    final formattedDate = '${getMonthName(date.month)} ${date.day}';
    return formattedDate;
  }


  Future<void> fetchTransactions() async {
    final apiUrl =
        'https://pattarya.besocial.pro/api/v1/paymenthistory?uid=${widget.uid}';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final List<dynamic> payments = jsonData['payments'];
      final List<Map<String, dynamic>> tempTransactions = [];

      for (int i = payments.length - 1; i >= 0 && tempTransactions.length < 3; i--) {
        final payment = payments[i];
        final transaction = {
          'date_of_payment': formatDate(payment['date_of_payment']),
          'type': payment['type'],
          'amount': payment['amount'],
        };
        tempTransactions.add(transaction);
      }

      setState(() {
        transactions = tempTransactions;
      });
    } else {
      print('Failed to fetch transactions');
    }
  }


  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kBlackColor,
        appBar: AppBar(
          title: Text(
            'PALLIPURAM PATTARYA SAMAJAM',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: kBlackColor, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: kBlackColor),
          toolbarHeight: 40,
        ),
        drawer: Drawer(
          width: width * .85,
          child: ListView(
            children: [
              SizedBox(
                height: height * .25,
                child: Stack(
                  children: [
                    Image.asset(
                      'images/draw.png',
                      height: 180,
                      fit: BoxFit.fill,
                    ),
                    Center(
                        child:  CircleAvatar(
                            maxRadius: 40,
                            backgroundColor: kTextField,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(40)),
                              child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40)),
                                    border: Border.all(width: 0.3),
                                    color: Colors.white,
                                  ),
                                  child: Image.asset(
                                      'images/godnew.jpeg', fit: BoxFit.cover,)),
                            )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.only(left: addPadding / 1),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.contact_support_outlined,
                          size: 30,
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        const Text(
                          'Contact Us',
                          style: TextStyle(
                            fontFamily: 'FrankRuhl',
                            fontSize: 22,
                            color: Color.fromRGBO(49, 39, 79, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.28,
                      child: Padding(
                        padding: const EdgeInsets.all(addPadding * 1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Address\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: kHeadDetail,
                                        fontWeight: FontWeight.w600),
                                children: [
                                  TextSpan(
                                    text:
                                        'Pattarya Samajam, Reg No: S20/69, Pallipuram P.O, Cherthala- 688541, Alapuzha',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: kHeadDetail, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Phone\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: kHeadDetail,
                                        fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: '+91-9072752535',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: kHeadDetail, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Email\n',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: kHeadDetail,
                                        fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: 'pattaryasamajamppm@gmail.com',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: kHeadDetail, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          size: 30,
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        InkWell(
                          onTap: () async {
                            final action = await AlertDialogs.yesCancelDialog(
                                context, 'Logout', 'Are you sure?');
                            if (action == DialogsAction.cancel) {
                              setState(() => tappedYes = true);
                            } else {
                              setState(() {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const LoginScreen();
                                }));
                              });
                            }
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              fontFamily: 'FrankRuhl',
                              fontSize: 22,
                              color: Color.fromRGBO(49, 39, 79, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.01,
              ),
              SizedBox(
                height: height * 0.125,
                child: InkWell(
                  onTap: () {
                    ShowDataAlert(uid: uid!).showAlert(
                      context,
                      'Alert Title',
                      'This is the alert body.',
                    );
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        'images/1.png',
                      ),
                      Positioned(
                        top: 30,
                        left: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Kudishika\n',
                                style: Theme.of(context).textTheme.bodyLarge,
                                children: [
                                  TextSpan(
                                    text: '(Total Dues)',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width * 0.07,
                            ),
                            RichText(
                              text: TextSpan(
                                text: '₹',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                children: [
                                  TextSpan(
                                    text: '$totalAmount',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            fontSize: 34,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              SizedBox(
                height: height * 0.125,
                child: InkWell(
                  onTap: () {
                    _show(context);
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        'images/1.png',
                      ),
                      Positioned(
                        top: 30,
                        left: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Sambhavana\n',
                                style: Theme.of(context).textTheme.bodyLarge,
                                children: [
                                  TextSpan(
                                    text: '(Donation)',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width * .25,
                            ),
                            const CircleAvatar(
                                maxRadius: 20,
                                backgroundColor: kPrimaryLight,
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: kHeadDetail,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              SizedBox(
                height: height * 0.125,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              AccountDetails(phoneNumber: widget.phoneNumber)),
                    );
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        'images/1.png',
                      ),
                      Positioned(
                        top: 30,
                        left: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Family Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontSize: 21),
                            ),
                            SizedBox(
                              width: width * .2,
                            ),
                            const CircleAvatar(
                                maxRadius: 20,
                                backgroundColor: kPrimaryLight,
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: kHeadDetail,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              SizedBox(
                height: height * 0.125,
                child: InkWell(
                  onTap: () {
                    Notice().NoticeBanner(
                      context,
                      'Alert Title',
                      'This is the alert body.',
                    );
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        'images/1.png',
                      ),
                      Positioned(
                        top: 30,
                        left: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Notice Board',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontSize: 21),
                            ),
                            SizedBox(
                              width: width * .22,
                            ),
                            const CircleAvatar(
                                maxRadius: 20,
                                backgroundColor: kPrimaryLight,
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: kHeadDetail,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              SizedBox(
                height: height * .34,
                width: double.infinity,
                child: Stack(
                  children: [
                    Image.asset(
                      'images/arc.png',
                      width: double.infinity,
                      height: height * .36,
                      fit: BoxFit.fill,
                    ),

                    transactions.isEmpty
                        ?
                    Positioned(
                      top: height*0.04,
                      left: width*0.15,
                      child: Column(
                    children: [
                      Image.asset('images/rect.png'),
                      SizedBox(
                        height: height * .1,
                      ),
                      SizedBox(
                        child: Center(
                            child: Text(
                              'No Previous Transaction',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontSize: 22),
                            )),
                      ),
                    ],
                      ),
                    ) :
                     Positioned(
                       top: 25,
                       left: 25,
                       child: Column(
                         children: [
                           Image.asset('images/rect.png'),
                           SizedBox(height: height*0.02,),
                           Text('Previous Transaction',style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kBlackColor, fontWeight: FontWeight.w600), ),
                           SizedBox(height: height*0.02,),
                           SizedBox(
                          height: height*0.01, width: width*.9,
                          child:  Flex(
                            direction: Axis.vertical,
                          children: [
                          const MySeparator(color: kBlackColor),
                            ],
                           ),),
                           SizedBox(
                             height: height*.23,
                             width: width*.8,
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: transactions.map((transaction) {
                                 final dateOfPayment = transaction['date_of_payment'];
                                 final type = transaction['type'];
                                 final amount = transaction['amount'];

                                 return Column(
                                   children: [
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             RichText(
                                                             text: TextSpan(
                                                               text: '${dateOfPayment.split(' ')[0]} ',
                                                               style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kAmount, fontWeight: FontWeight.w600),
                                                               children: [
                                                                 TextSpan(
                                                                     text:  '${dateOfPayment.split(' ')[1]}',
                                                                     style:Theme.of(context).textTheme.bodyLarge?.copyWith(color: kPrimaryColor, fontWeight: FontWeight.w600)),
                                                               ],
                                                             ),
                                                           ),

                                             SizedBox(
                                                 width: width*0.58,
                                                 child: Text('$type')),
                                           ],
                                         ),
                                         Text('$amount',style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kPrimaryColor, fontWeight: FontWeight.w600,fontSize: 22),),

                                       ],
                                     ),
                                     SizedBox(height: 8,),
                                     MySeparator(color: kPrimaryColor,)
                                   ],
                                 );
                               }).toList(),
                             ),

                           ),
                         ],
                       ),
                     )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _show(BuildContext ctx) {


    showModalBottomSheet(
        elevation: 10,
        backgroundColor: kPrimaryColor,
        context: ctx,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (ctx) => Sambhavana()

    );
  }

  @override
  void initState() {
    super.initState();
    fetchTotalAmount();
    fetchTransactions();
    user = FirebaseAuth.instance.currentUser;
    uid = user?.uid;
  }

}
