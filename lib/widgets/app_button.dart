import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/resources/app_constants.dart';

import '../resources/app_icons.dart';
import '../app_theme/app_colors.dart';

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

class AppPriorityPopupButton extends StatefulWidget {
  final String buttonTitle;
  final void Function(String importance) onSelected;
  String? selectedPriority;

  AppPriorityPopupButton({
    required this.buttonTitle,
    required this.onSelected,
    this.selectedPriority,
    Key? key,
  }) : super(key: key);

  @override
  State<AppPriorityPopupButton> createState() => _AppPriorityPopupButtonState();
}

class _AppPriorityPopupButtonState extends State<AppPriorityPopupButton> {
  @override
  Widget build(BuildContext context) {
    Brightness? brightness;
    List<String> values = [
      AppLocalizations.of(context)!.no,
      AppLocalizations.of(context)!.low,
      AppLocalizations.of(context)!.high,
    ];

    widget.selectedPriority ??= AppLocalizations.of(context)!.no;

    return PopupMenuButton<String>(
      initialValue: widget.selectedPriority,
      offset: const Offset(WidgetsSettings.smallScreenPadding, 0),
      shape: WidgetsSettings.roundedRectangleBorder(WidgetsSettings.cardRadius),
      splashRadius: WidgetsSettings.buttonSplashRadius,
      itemBuilder: (context) {
        return values
            .map(
              (priority) => PopupMenuItem(
                value: priority,
                child: Text(
                  priority == AppLocalizations.of(context)!.high
                      ? '!! $priority'
                      : priority,
                  style: priority == AppLocalizations.of(context)!.high
                      ? Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: brightness == Brightness.light
                                ? ToDoColors.redLight
                                : ToDoColors.redDark,
                          )
                      : Theme.of(context).textTheme.bodyText1,
                ),
              ),
            )
            .toList();
      },
      onSelected: (String priority) async {
        widget.onSelected(priority);
        setState(() {
          widget.selectedPriority = priority;
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          WidgetsSettings.smallScreenPadding,
          WidgetsSettings.noPadding,
          WidgetsSettings.smallScreenPadding,
          WidgetsSettings.smallScreenPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  bottom: WidgetsSettings.buttonPopUpPadding),
              child: Text(
                widget.buttonTitle,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Text(
              widget.selectedPriority!,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
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
      radius: WidgetsSettings.buttonSplashRadius,
      borderRadius: WidgetsSettings.roundedRectangleBorder(8),
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
