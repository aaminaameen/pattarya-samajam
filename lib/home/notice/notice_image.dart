

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:pattarya_samajam/home/widgets/alert_box.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class NoticeImage {
  Future<void> NoticeBanner(BuildContext ctx, String title, String body) async {


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
            return NoticeImages(image: '',);
          });
    }
  }

}


class NoticeImages extends StatefulWidget {
  const NoticeImages({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  State<NoticeImages> createState() => _NoticeImagesState();
}

class _NoticeImagesState extends State<NoticeImages> {
  @override
  Widget build(BuildContext context) {
    final double Height = MediaQuery.of(context).size.height;
    final double Width = MediaQuery.of(context).size.width;



    return AlertDialog(
      backgroundColor: kWhitColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            20.0,
          ),
        ),
      ),
      content: SizedBox(
        height: Height * .68,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: Height * 0.01,),
              Container(
                height: Height * .6,
                width: Width * .7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Image.network(widget.image, fit: BoxFit.fill,),

              ),
              SizedBox(height: Height*0.015,),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    http.Response response = await http.get(Uri.parse(widget.image));
                    if (response.statusCode == 200) {
                      await ImageGallerySaver.saveImage(Uint8List.fromList(response.bodyBytes));
                      return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertBox(content: Text("Your image is downloaded successfully"),
                              onPressed: () {
                            Navigator.of(context).pop();
                          },);
                        },
                      );
                    } else {
                      print('Failed to download image');
                    }
                  },
                  child: Container(
                    width: Width * .2,
                    height: Height * 0.05,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: kPrimaryColor, width: 2
                      ),
                    ),
                    child: Center(
                      child: Text('Download',
                        style: Theme
                            .of(context)
                            .textTheme
                            .button!
                            .copyWith(color: kWhitColor, fontSize: 8),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );


  }
}
