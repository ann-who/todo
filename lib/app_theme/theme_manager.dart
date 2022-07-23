import 'package:flutter/material.dart';
import 'package:todo_app/app_theme/app_colors.dart';

import '../resources/app_constants.dart';

class ThemeManager {
  // TODO implement dark theme (phase 2)

  static ThemeData theme(Brightness brightness) {
    ThemeData? themeData;

    if (brightness == Brightness.light) {
      themeData = ThemeData(
        appBarTheme: const AppBarTheme(
          color: ToDoColors.backPrimaryLight,
          iconTheme: IconThemeData(
            color: ToDoColors.blueLight,
          ),
        ),
        cardTheme: CardTheme(
          color: ToDoColors.backSecondaryLight,
          elevation: WidgetsSettings.cardElevation,
          shadowColor: ToDoColors.grayLightLight,
          margin: const EdgeInsets.all(WidgetsSettings.smallestScreenPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WidgetsSettings.cardRadius),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ToDoColors.blueLight,
          foregroundColor: ToDoColors.backSecondaryLight,
        ),
        iconTheme: const IconThemeData(color: ToDoColors.labelTertiaryLight),
        scaffoldBackgroundColor: ToDoColors.backPrimaryLight,
      );
    } else {
      themeData = ThemeData();
    }

    return themeData.copyWith();
  }
}
