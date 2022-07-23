import 'package:flutter/material.dart';
import 'package:todo_app/app_theme/app_colors.dart';

class ThemeManager {
  // TODO implement dark theme (phase 2)

  static ThemeData theme(Brightness brightness) {
    ThemeData? themeData;

    if (brightness == Brightness.light) {
      themeData = ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: ToDoColors.backPrimaryLight,
        appBarTheme: const AppBarTheme(
          color: ToDoColors.backPrimaryLight,
          iconTheme: IconThemeData(
            color: ToDoColors.blueLight,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: ToDoColors.blueLight,
          backgroundColor: ToDoColors.backPrimaryLight,
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: ToDoColors.labelPrimaryLight,
          ),
        ),
      );
    } else {
      themeData = ThemeData();
    }

    return themeData.copyWith();
  }
}
