import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/business_logic/task_detailed_screen/bloc_for_task_detailed_screen.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/resources/app_constants.dart';

class AppPriorityPopupButton extends StatelessWidget {
  const AppPriorityPopupButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness? brightness = MediaQuery.of(context).platformBrightness;
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
                  priority != AppLocalizations.of(context)!.high
                      ? priority
                      : '!! $priority',
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
