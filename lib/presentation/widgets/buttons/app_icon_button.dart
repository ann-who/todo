import 'package:flutter/material.dart';

import 'package:todo_app/app_theme/app_colors.dart';

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

    // TODO fit in listtile
    return InkWell(
      // child: GestureDetector(
      // padding: EdgeInsets.zero,
      // radius: WidgetsSettings.buttonSplashRadius,
      // borderRadius: WidgetsSettings.roundedRectangleBorder(8),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          iconPath,
          color: color ??
              (brightness == Brightness.light
                  ? ToDoColors.blueLight
                  : ToDoColors.blueDark),
        ),
      ),
      // ),
    );
  }
}
