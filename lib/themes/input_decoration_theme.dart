import "package:flutter/material.dart";
import '../core/constants/Constants.dart';


inputDecorationThemeLight() {
  return const InputDecorationTheme(
    // labelStyle: TextStyle(color: Colors.red),
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    hintStyle: TextStyle(color: Color(0xFFDADADA), fontSize: 16.0,fontFamily: "Poppins-Regular"),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Color(0xFFDADADA), width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Colors.red, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorStyle: TextStyle(color: Colors.red),
  );
}
