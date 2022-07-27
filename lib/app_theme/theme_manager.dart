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
          backgroundColor: ToDoColors.backPrimaryLight,
          iconTheme: IconThemeData(
            color: ToDoColors.labelPrimaryLight,
          ),
        ),
        brightness: Brightness.light,
        cardTheme: CardTheme(
          color: ToDoColors.backSecondaryLight,
          shadowColor: ToDoColors.grayLightLight,
          elevation: WidgetsSettings.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              WidgetsSettings.cardRadius,
            ),
          ),
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
            height: 38 / 32,
          ),
          headline2: TextStyle(
            fontSize: WidgetsSettings.appTitle,
            fontWeight: FontWeight.w500,
            color: ToDoColors.labelPrimaryLight,
            height: 32 / 20,
          ),
          subtitle1: TextStyle(
            fontSize: WidgetsSettings.appBodyText,
            fontWeight: FontWeight.w400,
            color: ToDoColors.labelTertiaryLight,
            height: 20 / 16,
          ),
          bodyText1: TextStyle(
            fontSize: WidgetsSettings.appBodyText,
            fontWeight: FontWeight.w400,
            color: ToDoColors.labelPrimaryLight,
            height: 20 / 16,
          ),
          button: TextStyle(
            fontSize: WidgetsSettings.appButtonText,
            fontWeight: FontWeight.w500,
            color: ToDoColors.blueLight,
            height: 24 / 14,
          ),
          caption: TextStyle(
            fontSize: WidgetsSettings.appSubheadText,
            fontWeight: FontWeight.w400,
            color: ToDoColors.labelTertiaryLight,
            height: 20 / 14,
          ),
        ),
      );
    } else {
      themeData = ThemeData(
        appBarTheme: const AppBarTheme(
          color: ToDoColors.backPrimaryDark,
          iconTheme: IconThemeData(
            color: ToDoColors.labelPrimaryDark,
          ),
        ),
        brightness: Brightness.dark,
        cardTheme: CardTheme(
          color: ToDoColors.backSecondaryDark,
          shadowColor: ToDoColors.grayLightDark,
          elevation: WidgetsSettings.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              WidgetsSettings.cardRadius,
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ToDoColors.blueDark,
          foregroundColor: ToDoColors.backSecondaryDark,
        ),
        iconTheme: const IconThemeData(
          color: ToDoColors.labelTertiaryDark,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            color: ToDoColors.labelTertiaryDark,
          ),
        ),
        listTileTheme: ListTileThemeData(tileColor: ToDoColors.greenDark),
        scaffoldBackgroundColor: ToDoColors.backPrimaryDark,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: WidgetsSettings.appLargeTitle,
            fontWeight: FontWeight.w500,
            color: ToDoColors.labelPrimaryDark,
            height: 38 / 32,
          ),
          headline2: TextStyle(
            fontSize: WidgetsSettings.appTitle,
            fontWeight: FontWeight.w500,
            color: ToDoColors.labelPrimaryDark,
            height: 32 / 20,
          ),
          subtitle1: TextStyle(
            fontSize: WidgetsSettings.appBodyText,
            fontWeight: FontWeight.w400,
            color: ToDoColors.labelTertiaryDark,
            height: 20 / 16,
          ),
          bodyText1: TextStyle(
            fontSize: WidgetsSettings.appBodyText,
            fontWeight: FontWeight.w400,
            color: ToDoColors.labelPrimaryDark,
            height: 20 / 16,
          ),
          button: TextStyle(
            fontSize: WidgetsSettings.appButtonText,
            fontWeight: FontWeight.w500,
            color: ToDoColors.blueDark,
            height: 24 / 14,
          ),
          caption: TextStyle(
            fontSize: WidgetsSettings.appSubheadText,
            fontWeight: FontWeight.w400,
            color: ToDoColors.labelTertiaryDark,
            height: 20 / 14,
          ),
        ),
      );
    }

    return themeData.copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
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
        minLeadingWidth: WidgetsSettings.listTilePadding,
        contentPadding: EdgeInsets.only(left: WidgetsSettings.listTilePadding),
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
