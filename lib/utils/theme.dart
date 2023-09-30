import 'package:flutter/material.dart';
import 'colors.dart';

class ThemeDataPrimary {
  static ThemeData primaryTheme = ThemeData(
      primaryColor: kPrimaryColor,
      colorScheme: const ColorScheme.light(primary: kPrimaryColor),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: kWhitColor,
            height: 1.2),
        displayMedium: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 32,
            color: kHeadDetail),
        displaySmall: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 25,
            color: kBlackColor),
        headlineMedium: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 26,
            color: kBlackColor),
        bodyLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: kWhitColor),
        bodyMedium: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: kTextGrey),
        labelLarge: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            color: kWhitColor,
            fontWeight: FontWeight.w600),
      ));
}
