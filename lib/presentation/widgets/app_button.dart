import 'package:flutter/material.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/resources/app_icons.dart';

// TODO change specific colors according to the theme

class AppTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String value;

  const AppTextButton({
    required this.onPressed,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness? brightness;

    return TextButton(
      onPressed: onPressed,
      child: Text(
        value.toUpperCase(),
        style: Theme.of(context).textTheme.button!.copyWith(
              color: brightness == Brightness.light
                  ? ToDoColors.blueLight
                  : ToDoColors.blueDark,
            ),
      ),
    );
  }
}

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
    Brightness? brightness;

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

class AppTextWithIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String value;
  final String iconPath;
  final Color? color;

  const AppTextWithIconButton({
    required this.onPressed,
    required this.value,
    required this.iconPath,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness? brightness;

    return Padding(
      padding: const EdgeInsets.only(
        left: WidgetsSettings.smallScreenPadding,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: WidgetsSettings.buttonTextIconPadding),
              child: AppIcon(
                path: iconPath,
                color: color ??
                    (brightness == Brightness.light
                        ? ToDoColors.redLight
                        : ToDoColors.redDark),
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.button!.copyWith(
                    color: color ??
                        (brightness == Brightness.light
                            ? ToDoColors.redLight
                            : ToDoColors.redDark),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
