import 'dart:convert';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../widgets/model_class.dart';
import 'package:http/http.dart' as http;
import 'notice_image.dart';


class Notice {
  Future<void> NoticeBanner(BuildContext ctx, String title, String body) async {

    final double Height = MediaQuery.of(ctx).size.height;
    final double Width = MediaQuery.of(ctx).size.width;

    final response = await http.get(Uri.parse(
        'https://pattarya.besocial.pro/api/v1/getAnyTableDatas?query=SELECT*FROM%20notice'));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print(response.body);
      List data = jsonData['data'];
      List<String> imageLinks = List<String>.from(
          data.map((item) => item['notice_link'])).toList();


      final action = await showDialog(
          context: ctx,
          builder: (ctx) {
            return AlertDialog(
              backgroundColor: kWhitColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              content: Container(
                height: Height * .68,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: Height * 0.01,),
                      RichText(
                        text: TextSpan(
                          text: 'Additional ',
                          style: TextStyle(
                              color: kBannerColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter'
                          ),
                          children: [
                            TextSpan(
                              text: ' Banner',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter'
                              ),),
                          ],
                        ),
                      ),
                      SizedBox(height: Height * 0.01,),
                      Flex(
                        direction: Axis.vertical,
                        children: [
                          const MySeparator(color: kBlackColor),
                        ],
                      ),
                      SizedBox(height: Height * 0.02,),
                      Container(
                        height: Height * .54,
                        width: Width * .7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child: SizedBox(
                          height: Height * .54,
                          width: Width * .51,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: imageLinks.length,
                            itemBuilder: (context, index) =>
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                      height: Height * .15,
                                      width: Width * .51,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius
                                              .circular(20),
                                          child:  InkWell(
                                              onTap: (){

                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) => NoticeImages(image: 'https://pattarya.besocial.pro/'+imageLinks[index],)),
                                                );
                                              },

                                              child: Image.network('https://pattarya.besocial.pro/'+imageLinks[index], fit: BoxFit.cover,)),
                                        ),
                                      )
                                  ),
                                ),
                          ),
                        ),
                      ),
                       SizedBox(height: Height*0.005,),
                    ],
                  ),
                ),
              ),
            );
          });
    }
  }

}

