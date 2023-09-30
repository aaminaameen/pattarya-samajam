import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'model_class.dart';



class MyTextFormField extends StatelessWidget {
  final String labelText;
  final String initialValue;
  final bool readOnly;
  final TextInputType keyboardType;
  final Function(String)? onChanged;

  const MyTextFormField({
    Key? key,
    required this.labelText,
    required this.initialValue,
    this.readOnly = true,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17),
        ),
        SizedBox(height: 40,
          child: TextFormField(
            decoration: const InputDecoration(
              border: InputBorder.none,),
            readOnly: readOnly,
            initialValue: initialValue,
            keyboardType: keyboardType,
            onChanged: onChanged,
          ),
        ),
        const MySeparator(color: kBlackColor),
      ],
    );
  }
}