import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/business_logic/task_detailed_screen/bloc_for_task_detailed_screen.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/resources/app_icons.dart';

class AppTextWithIconButton extends StatelessWidget {
  const AppTextWithIconButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness? brightness = MediaQuery.of(context).platformBrightness;

    var enabledColor = (brightness == Brightness.light)
        ? ToDoColors.redLight
        : ToDoColors.redDark;
    var disabledColor = (brightness == Brightness.light)
        ? ToDoColors.labelDisableLight
        : ToDoColors.labelDisableDark;

    return BlocBuilder<TaskDetailedScreenBloc, TaskDetailedScreenState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            left: WidgetsSettings.smallScreenPadding,
          ),
          child: TextButton(
            onPressed: state.isNewTask || state.status.isLoadingOrSuccess
                ? null
                : () => context
                    .read<TaskDetailedScreenBloc>()
                    .add(const TaskDeleted()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      right: WidgetsSettings.buttonTextIconPadding),
                  child: AppIcon(
                    path: IconResources.delete,
                    color: state.isNewTask || state.status.isLoadingOrSuccess
                        ? disabledColor
                        : enabledColor,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.delete,
                  style: Theme.of(context).textTheme.button!.copyWith(
                        color:
                            state.isNewTask || state.status.isLoadingOrSuccess
                                ? disabledColor
                                : enabledColor,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
