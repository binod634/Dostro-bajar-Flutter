import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(colorScheme: colorTheme);
}

var colorTheme = ColorScheme.light(
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade50,
    surface: Colors.grey.shade300,
    inversePrimary: Colors.grey.shade700);
