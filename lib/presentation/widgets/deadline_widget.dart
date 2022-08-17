import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:todo_app/app_theme/app_colors.dart';

import 'package:todo_app/business_logic/task_detailed_screen/bloc_for_task_detailed_screen.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/presentation/widgets/task_deadline_calendar.dart';
import 'package:todo_app/resources/app_constants.dart';

class DeadlineWidget extends StatelessWidget {
  const DeadlineWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness? brightness = MediaQuery.of(context).platformBrightness;
    // TODO get system locale
    final DateFormat formatter = DateFormat.yMMMMd('ru');

    return Padding(
      padding: const EdgeInsets.only(
        left: WidgetsSettings.smallScreenPadding,
        right: WidgetsSettings.smallScreenPadding,
        bottom: WidgetsSettings.bigScreenPadding,
      ),
      child: SwitchListTile(
        value: context.watch<TaskDetailedScreenBloc>().state.hasDeadline,
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
            //! TODO refactor implementation
            builder: (context) => BlocProvider(
              create: (context) => TaskDetailedScreenBloc(
                taskRepository: context.read<TaskRepository>(),
              ),
              child: AlertDialog(
                content: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.4,
                  width: MediaQuery.of(context).size.width -
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
          var currentDeadline =
              context.read<TaskDetailedScreenBloc>().state.deadline;
          if (deadline != null && deadline != currentDeadline) {
            context
                .read<TaskDetailedScreenBloc>()
                .add(TaskDeadlineChanged(deadline));
          }
        },
        title: Text(
          AppLocalizations.of(context)!.deadline,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        subtitle: BlocBuilder<TaskDetailedScreenBloc, TaskDetailedScreenState>(
          builder: (context, state) {
            if (!state.hasDeadline) {
              return Container();
            }

            String formatted = formatter.format(
              DateTime.fromMillisecondsSinceEpoch(state.deadline * 1000),
            );

            return Text(
              formatted,
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: brightness == Brightness.light
                        ? ToDoColors.blueLight
                        : ToDoColors.blueDark,
                  ),
            );
          },
        ),
      ),
    );
  }
}
