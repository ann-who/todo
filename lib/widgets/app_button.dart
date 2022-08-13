import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/screens/task_detailed_screen/bloc/task_detailed_screen_bloc.dart';
import 'package:todo_app/screens/task_detailed_screen/bloc/task_detailed_screen_event.dart';
import 'package:todo_app/screens/task_detailed_screen/bloc/task_detailed_screen_state.dart';

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

class AppPriorityPopupButton extends StatelessWidget {
  const AppPriorityPopupButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness? brightness;
    List<String> values = [
      AppLocalizations.of(context)!.no,
      AppLocalizations.of(context)!.low,
      AppLocalizations.of(context)!.high,
    ];

    var importanceToString = {
      Importance.basic: AppLocalizations.of(context)!.no,
      Importance.low: AppLocalizations.of(context)!.low,
      Importance.important: AppLocalizations.of(context)!.high,
    };
    var stringToImportance = {
      AppLocalizations.of(context)!.no: Importance.basic,
      AppLocalizations.of(context)!.low: Importance.low,
      AppLocalizations.of(context)!.high: Importance.important,
    };

    return PopupMenuButton<String>(
      initialValue: importanceToString[
          context.read<TaskDetailedScreenBloc>().state.importance],
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
      onSelected: (String importance) async {
        context
            .read<TaskDetailedScreenBloc>()
            .add(TaskImportanceChanged(stringToImportance[importance]!));
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
                AppLocalizations.of(context)!.priority,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            BlocBuilder<TaskDetailedScreenBloc, TaskDetailedScreenState>(
              builder: (context, state) {
                return Text(
                  importanceToString[state.importance]!,
                  style: Theme.of(context).textTheme.caption,
                );
              },
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
