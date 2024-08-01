import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.pink,
  hintColor: Colors.pinkAccent,
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.pink,
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(fontSize: 16),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);
