import 'package:flutter/material.dart';

class WidgetsSettings {
  /// Settings for general widgets

  static const double noPadding = 0.0;
  static const double smallestScreenPadding = 8.0;
  static const double smallScreenPadding = 16.0;
  static const double mediumScreenPadding = 22.0;
  static const double bigScreenPadding = 28.0;
  static const double biggestScreenPadding = 50.0;

  static const double appLargeTitle = 32.0;
  static const double appTitle = 20.0;
  static const double appBodyText = 16.0;
  static const double appButtonText = 14.0;
  static const double appSubheadText = 14.0;

  static const double buttonPopUpPadding = 4.0;
  static const double buttonTextIconPadding = 16.0;
  static const double buttonSplashRadius = 18.0;

  static const double cardElevation = 4.0;
  static const double cardRadius = 8.0;

  static const double checkBoxRadius = 2.0;

  static const double dividerHeight = 0.5;

  static const double iconRadius = 20.0;
  static const double iconBorderRadius = 30.0;

  static const double listTileVerticalPadding = 12.0;
  static const double listTileHorizontalPadding = 16.0;
  static const double listTileSmallPadding = 6.0;
  static const double listTileSmallestPadding = 3.0;

  static const double titlePadding = 6.0;
  static const double subtitlePadding = 18.0;

  static const double wideAppBarBiggestPadding = 60.0;
  static const double wideAppBarMediumPadding = 24.0;
  static const double wideAppBarSmallPadding = 16.0;

  static const int textFieldMinHeight = 5;
  static const double textFieldPadding = 36.0;
  static const int textTaskMaxHeight = 3;

  static const int animationDuration = 100;

  static roundedRectangleBorder(double radius) {
    BorderRadius.circular(
      radius,
    );
  }

  /// Settings for data source

  static const String domainUrl = 'beta.mrdekk.ru';
  static const String baseUrl = 'https://$domainUrl/todobackend';
  static const int connectTimeout = 5000;
  static const int receiveTimeout = 3000;
  static const String myToken = 'YOUR TOKEN HERE';

  /// Const messages

  static const String dsError = 'Error occured on data source. Try later';
  static const String revisionError =
      'Revision error occured. Try one more time';
  static const String notFound = 'Task is not found';
  static const String deviceId = 'Can\'t get device id';
}
