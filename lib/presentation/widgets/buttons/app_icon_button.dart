import 'package:flutter/material.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/resources/app_constants.dart';

class AppIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData iconPath;
  final Color? color;

  const AppIconButton({
    required this.onPressed,
    required this.iconPath,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness? brightness = MediaQuery.of(context).platformBrightness;

    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WidgetsSettings.iconBorderRadius),
      ),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(WidgetsSettings.listTileSmallPadding),
        child: Icon(
          iconPath,
          color: color ??
              (brightness == Brightness.light
                  ? ToDoColors.blueLight
                  : ToDoColors.blueDark),
        ),
      ),
    );
  }
}
