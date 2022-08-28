import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/business_logic/task_detailed_screen/bloc_for_task_detailed_screen.dart';
import 'package:todo_app/presentation/widgets/task_deadline_calendar.dart';
import 'package:todo_app/resources/app_constants.dart';

class DeadlineWidget extends StatelessWidget {
  const DeadlineWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness? brightness = MediaQuery.of(context).platformBrightness;
    final DateFormat formatter =
        DateFormat.yMMMMd(Localizations.localeOf(context).languageCode);

    return Padding(
      padding: const EdgeInsets.only(
        left: WidgetsSettings.smallScreenPadding,
        right: WidgetsSettings.smallScreenPadding,
        bottom: WidgetsSettings.bigScreenPadding,
      ),
      child: BlocBuilder<TaskDetailedScreenBloc, TaskDetailedScreenState>(
        buildWhen: (previous, current) => previous.deadline != current.deadline,
        builder: (context, state) {
          return SwitchListTile(
            value: state.hasDeadline,
            activeColor: brightness == Brightness.light
                ? ToDoColors.blueLight
                : ToDoColors.blueDark,
            onChanged: (bool newState) async {
              if (newState == false) {
                context
                    .read<TaskDetailedScreenBloc>()
                    .add(const TaskDeadlineChanged());
                return;
              }

              int? deadline = await showDialog(
                context: context,
                builder: (dialogContext) => BlocProvider.value(
                  value: context.read<TaskDetailedScreenBloc>(),
                  child: AlertDialog(
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height <= 800
                          ? MediaQuery.of(dialogContext).size.height / 1.4
                          : MediaQuery.of(dialogContext).size.height / 2.0,
                      width: MediaQuery.of(dialogContext).size.width -
                          WidgetsSettings.smallScreenPadding,
                      child: const TaskDeadlineCalendar(),
                    ),
                    contentPadding: const EdgeInsets.all(
                      WidgetsSettings.noPadding,
                    ),
                    backgroundColor: ToDoColors.backSecondaryLight,
                  ),
                ),
              );

              var currentDeadline = state.deadline;

              if (deadline == null || deadline == currentDeadline) {
                return;
              }

              // @dzolotov как понимаю, эта ошидка для statefull и ложно срабатывает?
              // ignore: use_build_context_synchronously
              context
                  .read<TaskDetailedScreenBloc>()
                  .add(TaskDeadlineChanged(deadline));
            },
            title: Text(
              AppLocalizations.of(context)!.deadline,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            subtitle: !state.hasDeadline
                ? null
                : Text(
                    formatter.format(
                      DateTime.fromMillisecondsSinceEpoch(state.deadline),
                    ),
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: brightness == Brightness.light
                              ? ToDoColors.blueLight
                              : ToDoColors.blueDark,
                        ),
                  ),
          );
        },
      ),
    );
  }
}
