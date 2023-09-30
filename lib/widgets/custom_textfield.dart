import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final Widget? icon;
  final Widget? suficon;
  final TextEditingController? controller;
  final TextInputType? keyboard;


  const CustomTextField({
    Key? key,required this.hintText, this.icon, this.controller,
    this.validator, this.onSaved, this.onChanged, this.suficon, this.keyboard
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 70,
          child: TextFormField(
            keyboardType: keyboard,
            controller: controller,
            validator: validator,
            onSaved: onSaved,
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: kTextField,
              enabledBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: icon,
              suffixIcon: suficon,
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 16,
                color: kHintText,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class TextFieldFamily extends StatelessWidget {
  const TextFieldFamily({
    Key? key, required this.hintText, this.controller, this.keyboard,
    this.validator, this.onChanged, this.initialValue,
  }) : super(key: key);

  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboard;
  final void Function(String)? onChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height*0.07,
      child: TextFormField(
        initialValue: initialValue,
        validator: validator,
        keyboardType: keyboard,
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: kWhitColor,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 14,
              color: kTextFieldBottom, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}