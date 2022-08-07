import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconResources {
  static const String path = 'assets/app_icons';

  static const String add = '$path/add.svg';
  static const String arrowBack = '$path/arrow_back.svg';
  static const String check = '$path/check.svg';
  static const String close = '$path/close.svg';
  static const String delete = '$path/delete.svg';
  static const String infoOutline = '$path/info_outline.svg';
  static const String priorityHigh = '$path/priority_high.svg';
  static const String priorityLow = '$path/priority_low.svg';
  static const String visibility = '$path/visibility.svg';
  static const String visibilityOff = '$path/visibility_off.svg';
}

class AppIcon extends StatelessWidget {
  final String path;
  final Color? color;
  final double? width;
  final double? height;

  const AppIcon({
    required this.path,
    this.color,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      color: color,
      width: width,
      height: height,
    );
  }
}
