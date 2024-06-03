
import "package:flutter/material.dart";


textButtonThemeLight() {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.blue,
      textStyle: const TextStyle(
        fontFamily: "SFProRegular",
        fontSize: 16,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
    ),
  );
}

elevatedButtonThemeLight() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue,
      elevation: 0,
      minimumSize: const Size(180, 55),
      textStyle: const TextStyle(
        fontFamily: "SFProRegular",
        fontSize: 15,
      ),
      padding:const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  );
}
