import "package:flutter/material.dart";
import 'button_theme.dart';
import 'input_decoration_theme.dart';

enum MyAppThemeKeys { LIGHT, DARK }

class MyAppTheme {
  static final ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      color: Colors.blue,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      titleTextStyle: TextStyle(
          fontFamily: "Inter", fontSize: 14, color: Colors.white),
      centerTitle: true,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    fontFamily: "Inter",
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.white, // Your accent color
    ),
    unselectedWidgetColor: Colors.blue,
    elevatedButtonTheme: elevatedButtonThemeLight(),
    inputDecorationTheme: inputDecorationThemeLight(),
    // textButtonTheme: textButtonThemeLight(),
    // textTheme: textThemeLight(),
    // inputDecorationTheme: inputDecorationThemeLight(),
    // textSelectionTheme: const TextSelectionThemeData(
    //   cursorColor: AppColors.primaryElement,
    // )
  );

  static ThemeData getThemeFromKey(MyAppThemeKeys themeKey) {
    switch (themeKey) {
      case MyAppThemeKeys.LIGHT:
        return lightTheme;
      default:
        return lightTheme;
    }
  }
}
