import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../widgets/model_class.dart';
import 'kudishika_total_due.dart';

class Kudishika extends StatefulWidget {
  const Kudishika({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  State<Kudishika> createState() => _KudishikaState();
}

class _KudishikaState extends State<Kudishika> {
  TextEditingController amntController = TextEditingController();
  int masavariDue = 0;
  int kudumbaSahayamDue = 0;
  int ulsavaVihitamDue = 0;
  int specialDonationDue = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String? uid;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _show(context);
      },
      child: Stack(
        children: [
          Image.asset(
            'images/2.png',
            height: widget.height * .14,
            fit: BoxFit.fill,
          ),
          Positioned(
            top: 20,
            right: 80,
            left: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Total Kudishika\n',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 14),
                    children: [
                      TextSpan(
                        text: '(Total Dues)',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: widget.height * 0.035,
                ),
                SizedBox(
                  height: widget.height * 0.01,
                  child: Flex(
                    direction: Axis.vertical,
                    children: const [
                      MySeparator(color: kWhitColor),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
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
        builder: (ctx) => const KudishikaTotalDue());
  }
}
