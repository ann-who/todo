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
        brightness: Brightness.light,
        cardTheme: const CardTheme(
          color: ToDoColors.backSecondaryLight,
          shadowColor: ToDoColors.grayLightLight,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ToDoColors.blueLight,
          foregroundColor: ToDoColors.backSecondaryLight,
        ),
        iconTheme: const IconThemeData(
          color: ToDoColors.labelTertiaryLight,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            color: ToDoColors.labelTertiaryLight,
          ),
        ),
        scaffoldBackgroundColor: ToDoColors.backPrimaryLight,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: WidgetsSettings.appLargeTitle,
            fontWeight: FontWeight.w500,
            color: ToDoColors.labelPrimaryLight,
          ),
          headline2: TextStyle(
            fontSize: WidgetsSettings.appTitle,
            fontWeight: FontWeight.w500,
            color: ToDoColors.labelPrimaryLight,
          ),
          bodyText1: TextStyle(
            fontSize: WidgetsSettings.appBodyText,
            fontWeight: FontWeight.w400,
            color: ToDoColors.labelPrimaryLight,
          ),
          button: TextStyle(
            fontSize: WidgetsSettings.appButtonText,
            fontWeight: FontWeight.w500,
            color: ToDoColors.blueLight,
          ),
          caption: TextStyle(
            fontSize: WidgetsSettings.appSubheadText,
            fontWeight: FontWeight.w400,
            color: ToDoColors.labelTertiaryLight,
          ),
        ),
      );
    } else {
      themeData = ThemeData();
    }

    return themeData.copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardTheme: CardTheme(
        elevation: WidgetsSettings.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            WidgetsSettings.cardRadius,
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          fontSize: WidgetsSettings.appBodyText,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: EdgeInsets.all(
          WidgetsSettings.smallScreenPadding,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      listTileTheme: const ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(WidgetsSettings.cardRadius),
            bottomRight: Radius.circular(WidgetsSettings.cardRadius),
          ),
        ),
      ),
    );
  }
}
