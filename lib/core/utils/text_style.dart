import 'package:flutter/material.dart';

class AppTextStyles {
  static const String fontFamilyName = 'SFProRegular';

  static TextStyle regular(
          {double fontSize = 14, Color? color = Colors.black}) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamilyName,
      );

  static TextStyle medium(
          {double fontSize = 16, Color? color = Colors.black}) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamilyName,
      );

  static TextStyle bold(
          {double fontSize = 16, Color? color = Colors.black}) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamilyName,
      );
  static TextStyle light(
      {double fontSize = 14, FontWeight? fontWeight,  Color? color = Colors.black}) =>
      TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight?? FontWeight.w400,
        fontFamily: fontFamilyName,
      );
}
