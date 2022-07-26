import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/resources/app_constants.dart';

import '../resources/app_icons.dart';
import '../app_theme/app_colors.dart';

// TODO change specific colors according to the theme

class AppTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final String value;

  const AppTextButton(this.onPressed, this.value, {Key? key}) : super(key: key);

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

class AppPriorityPopupButton extends StatelessWidget {
  // final Function(String)? onSelected;
  final String buttonTitle;
  final String? selectedPriority;

  const AppPriorityPopupButton({
    // required this.onSelected,
    required this.buttonTitle,
    this.selectedPriority,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String selectedPriority = AppLocalizations.of(context)!.no;
    List<String> values = [
      AppLocalizations.of(context)!.no,
      AppLocalizations.of(context)!.low,
      AppLocalizations.of(context)!.high,
    ];
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      // onSelected: onSelected,
      itemBuilder: (_) {
        return values
            .map(
              (priority) => PopupMenuItem(
                value: priority,
                child: Row(
                  children: <Widget>[
                    Text(
                      priority,
                    ),
                  ],
                ),
              ),
            )
            .toList();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: WidgetsSettings.smallScreenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              buttonTitle,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: WidgetsSettings.buttonPopUpPadding,
            ),
            Text(
              selectedPriority,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final String iconPath;
  final Color? color;

  const AppIconButton(this.onPressed, this.iconPath, {this.color, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness? brightness;

    return IconButton(
      padding: const EdgeInsets.all(WidgetsSettings.noPadding),
      splashRadius: WidgetsSettings.buttonSplashRadius,
      onPressed: onPressed,
      icon: AppIcon(
        path: iconPath,
        color: color ??
            (brightness == Brightness.light
                ? ToDoColors.blueLight
                : ToDoColors.blueDark),
      ),
    );
  }
}

class AppTextWithIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final String value;
  final String iconPath;

  const AppTextWithIconButton(this.onPressed, this.value, this.iconPath,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness? brightness;

    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon(
            path: iconPath,
            color: brightness == Brightness.light
                ? ToDoColors.redLight
                : ToDoColors.redDark,
          ),
          const SizedBox(
            width: WidgetsSettings.buttonTextIconPadding,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.button!.copyWith(
                  color: brightness == Brightness.light
                      ? ToDoColors.redLight
                      : ToDoColors.redDark,
                ),
          ),
        ],
      ),
    );
  }
}
