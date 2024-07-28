import 'package:flutter/material.dart';


class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Montserrat",
    primaryColor: const Color.fromRGBO(82, 82, 82, 1)

  );
  static ThemeData darkTheme = ThemeData();
}