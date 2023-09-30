import 'package:flutter/material.dart';
import '../utils/colors.dart';


class CustomButton extends StatelessWidget {
  final Color buttonColor;
  final Color borderColor;
  final Color textColor;
  final String text;
  final Function() ontap;
  const CustomButton({
    Key? key,
    this.borderColor = kBlackColor,
    this.buttonColor = kBlackColor,
    this.textColor = kWhitColor,
    required this.text,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
                color: borderColor, width: 2
            ),
          ),

          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
