import 'package:flutter/material.dart';
import 'package:tsscourses/core/setting.dart';

class MyAppThemes {
  static final lightTheme = ThemeData(
    primaryColor: Setting.white,
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    primaryColor: Setting.bgColor,
    brightness: Brightness.dark,
  );
}