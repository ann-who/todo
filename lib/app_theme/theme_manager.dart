import 'package:flutter/material.dart';
import 'package:todo_app/app_theme/app_colors.dart';

import '../resources/app_constants.dart';

class ThemeManager {
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
          elevation: WidgetsSettings.cardElevation,
          shape: WidgetsSettings.roundedRectangleBorder(
            WidgetsSettings.cardRadius,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          shape: WidgetsSettings.roundedRectangleBorder(
            WidgetsSettings.checkBoxRadius,
          ),
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return ToDoColors.greenLight;
            }
            return ToDoColors.separatorLight;
          }),
          checkColor: MaterialStateProperty.all<Color>(
            ToDoColors.backSecondaryLight,
          ),
          side: const BorderSide(
            width: WidgetsSettings.checkBoxRadius,
            color: ToDoColors.separatorLight,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ToDoColors.blueLight,
          foregroundColor: ToDoColors.backSecondaryLight,
        ),
        iconTheme: const IconThemeData(
          color: ToDoColors.labelTertiaryLight,
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
        colorScheme: const ColorScheme.dark(
          primary: ToDoColors.blueDark,
          secondary: ToDoColors.blueDark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ToDoColors.backPrimaryDark,
          iconTheme: IconThemeData(
            color: ToDoColors.labelPrimaryDark,
          ),
          foregroundColor: ToDoColors.labelPrimaryDark,
        ),
        brightness: Brightness.dark,
        cardTheme: CardTheme(
          color: ToDoColors.backSecondaryDark,
          elevation: WidgetsSettings.noPadding,
          shape: WidgetsSettings.roundedRectangleBorder(
            WidgetsSettings.cardRadius,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          shape: WidgetsSettings.roundedRectangleBorder(
            WidgetsSettings.checkBoxRadius,
          ),
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return ToDoColors.greenDark;
            }
            return ToDoColors.separatorDark;
          }),
          checkColor: MaterialStateProperty.all<Color>(
            ToDoColors.backSecondaryDark,
          ),
          side: const BorderSide(
            width: WidgetsSettings.checkBoxRadius,
            color: ToDoColors.separatorDark,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ToDoColors.blueDark,
          foregroundColor: ToDoColors.backSecondaryDark,
        ),
        iconTheme: const IconThemeData(
          color: ToDoColors.labelTertiaryDark,
        ),
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
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
