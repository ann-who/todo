import 'package:flutter/material.dart';

class IconResources {
  static const String add = 'assets/app_icons/add.png';
  static const String arrowBack = 'assets/app_icons/arrow_back.png';
  static const String check = 'assets/app_icons/check.png';
  static const String checked = 'assets/app_icons/checked.png';
  static const String close = 'assets/app_icons/close.png';
  static const String delete = 'assets/app_icons/delete.png';
  static const String infoOutline = 'assets/app_icons/info_outline.png';
  static const String switchOff = 'assets/app_icons/switch_off.png';
  static const String switchOn = 'assets/app_icons/switch_on.png';
  static const String unchecked = 'assets/app_icons/unchecked.png';
  static const String uncheckedUrgent = 'assets/app_icons/unchecked_urgent.png';
  static const String visibility = 'assets/app_icons/visibility.png';
  static const String visibilityOff = 'assets/app_icons/visibility_off.png';
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
    return Image.asset(
      path,
      color: color,
    );
  }
}
