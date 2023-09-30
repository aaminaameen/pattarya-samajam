import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';

class AlertBox extends StatelessWidget {
  const AlertBox({
    Key? key, required this.content, required this.onPressed,
  }) : super(key: key);
  final Widget content;
  final void Function() onPressed;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const  Text("Success"),
      content: content,
      actions: [
        TextButton(
          onPressed: onPressed,
          child: const Text("OK",style: TextStyle(color: kPrimaryColor),),
        ),
      ],
    );
  }
}




class KudishikaCheckBox extends StatelessWidget {
  const KudishikaCheckBox({this.onChanged,
    Key? key, this.value,
  }) : super(key: key);
  final void Function(bool?)? onChanged;
  final  bool? value;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
        shape: const CircleBorder(),
        checkColor: kBlackColor,
        fillColor: MaterialStateProperty.resolveWith((states) => kCheckBox),
        value: value,
        onChanged: onChanged
    );
  }

}