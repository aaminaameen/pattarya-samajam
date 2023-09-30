import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pattarya_samajam/utils/constants.dart';
import 'package:pattarya_samajam/home/screen/home_screen.dart';

import '../../utils/colors.dart';



class PaymentConfirm extends StatefulWidget {
  const PaymentConfirm({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<PaymentConfirm> createState() => _PaymentConfirmState();
}

class _PaymentConfirmState extends State<PaymentConfirm> {

  double lastPaymentAmount = 0.0;

  Future<void> fetchDonationData() async {
    final response = await http.get(
      Uri.parse('https://pattarya.besocial.pro/api/v1/getTableDatas?table=donation&where=uid&value=${widget.uid}'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final data = jsonData['data'];
      if (data != null && data is List && data.isNotEmpty) {
        setState(() {
          lastPaymentAmount = double.parse(data.last['amount'].toString());
        });
      }
    } else {
      throw Exception('Failed to fetch donation data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDonationData();
  }


  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;


    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: height*0.03,),
            Stack(
              children: [
                Image.asset('images/ticket.png',),
                Positioned(
                  top: 40,
                  left: 55,
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Image.asset('images/profile.png'),
                        SizedBox(height: height*0.03,),
                        Center(
                          child: SizedBox(
                          height: height*.13,
                          width: width*.35,
                          child: Column(
                            children: [
                              SizedBox(height: height*.02,),
                              Text('Great', style:  Theme.of(context).textTheme.bodyLarge?.copyWith(color: kLinear),),
                              SizedBox(height: height*.02,),
                              Text('Sambhavana', style:  Theme.of(context).textTheme.bodyLarge?.copyWith(color: kLinear, fontSize: 18),),
                             const Text('below is your summary'),
                            ],
                          ),),
                        ),
                     SizedBox(
                          height: height*.28,
                          width: width*.7,
                          child: Column(
                            children: [
                              SizedBox(height: height*0.04,),
                              Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Sambhavana', style:  Theme.of(context).textTheme.bodyLarge?.copyWith(color: kGreyLight, fontSize: 18),),
                                  Text( 'Rs ${lastPaymentAmount.toStringAsFixed(2)}', style:  Theme.of(context).textTheme.bodyLarge?.copyWith(color: Color(0xff505050), fontSize: 20),),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text('Total Amount',style:  Theme.of(context).textTheme.bodyLarge?.copyWith(color: kGreyLight, height: 1.5, fontSize: 15),),
                        Text('Rs ${lastPaymentAmount.toStringAsFixed(2)}',style:  Theme.of(context).textTheme.bodyLarge?.copyWith(color: kPrimaryColor, fontSize: 24, height: 1.5,),),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: height*.03,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>const HomeScreen(phoneNumber: '', uid: '')));
              },
              child: Container(
                width: width*.71,
                height: height*0.07,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient:const  LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomLeft,
                      colors: [
                        kPrimaryColor,
                        Color.fromRGBO(240, 200, 1, 0),
                      ],
                      stops: [0.351, 1.9],
                    )
                ),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Back to',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20,color: kWhitColor),
                      children: [
                        TextSpan(
                          text: ' Home ',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20,),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),

      ),
    );
  }
}
