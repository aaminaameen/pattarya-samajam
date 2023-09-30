import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pattarya_samajam/home/screen/home_screen.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;


class WelfareConfirm extends StatefulWidget {
  const WelfareConfirm({Key? key, required this.welfareContribution, required this.uid}) : super(key: key);
  final String welfareContribution;
  final String uid;

  @override
  State<WelfareConfirm> createState() => _WelfareConfirmState();
}

class _WelfareConfirmState extends State<WelfareConfirm> {
  int totalAmount = 0;
  int pendingAmount = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }


  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://pattarya.besocial.pro/api/v1/getTableDatas?table=kudishika&where=uid&value=${widget.uid}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final welfareDue = data['data'][0]['kudumba_sahayam_due'];

      setState(() {
        pendingAmount = welfareDue;
        totalAmount = pendingAmount + int.parse(widget.welfareContribution) ;
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {

    final double Height = MediaQuery.of(context).size.height;
    final double Width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Image.asset('images/ticket.png',),
                Positioned(
                  top: 40,
                  left: 30,
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Image.asset('images/profile.png'),
                        SizedBox(height: Height*0.03,),
                        Center(
                          child: SizedBox(
                            height: Height*0.13,
                            width: Width*.85,
                            child: Column(
                              children: [
                                SizedBox(height: Height*0.02,),
                                Text('Great', style:  Theme.of(context).textTheme.bodyText1?.copyWith(color: kLinear),),
                                SizedBox(height: Height*0.02,),
                                Text('Welfare Contribution', style:  Theme.of(context).textTheme.bodyText1?.copyWith(color: kBlackColor, fontSize: 18),),
                                Text('below is your summary'),
                              ],
                            ),),
                        ),
                        SizedBox(
                          height: Height*.28,
                          width: Width*.7,
                          child: Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: Height*0.05,),
                              Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Amount', style:  Theme.of(context).textTheme.bodyText1?.copyWith(color: kGreyLight, fontSize: 18),),
                                  Text('Rs $totalAmount', style:  Theme.of(context).textTheme.bodyText1?.copyWith(color: Color(0xff505050), fontSize: 20),),
                                ],
                              ),
                              Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Paid', style:  Theme.of(context).textTheme.bodyText1?.copyWith(color: kGreyLight, fontSize: 18),),
                                  Text( 'Rs ${widget.welfareContribution}', style:  Theme.of(context).textTheme.bodyText1?.copyWith(color: Color(0xff505050), fontSize: 20),),
                                ],
                              ),
                              Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Pending Due', style:  Theme.of(context).textTheme.bodyText1?.copyWith(color: kLinear, fontSize: 18),),
                                  Text('Rs $pendingAmount', style:  Theme.of(context).textTheme.bodyText1?.copyWith(color: kLinear, fontSize: 20),),
                                ],
                              ),
                              SizedBox(height: Height*0.03,),
                            ],
                          ),
                        ),
                        Text('Paid Amount',style:  Theme.of(context).textTheme.bodyText1?.copyWith(color: kGreyLight, height: 1.5, fontSize: 15),),
                        Text('Rs ${widget.welfareContribution}',style:  Theme.of(context).textTheme.bodyText1?.copyWith(color: kPrimaryColor, fontSize: 24, height: 1.5),),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: Height*0.03,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(phoneNumber: '', uid: '',)));
              },
              child: Container(
                width: Width*.71,
                height: Height*0.07,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
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
                      style: Theme.of(context).textTheme.headline4?.copyWith(fontSize: 20,color: kWhitColor),
                      children: [
                        TextSpan(
                          text: ' Home ',
                          style: Theme.of(context).textTheme.headline4?.copyWith(fontSize: 20,),
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
