import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/widgets/task_deadline_calendar.dart';

import '../resources/app_constants.dart';

class DeadlineWidget extends StatefulWidget {
  int deadline;
  final void Function(int deadline) onSelected;

  DeadlineWidget({
    required this.deadline,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<DeadlineWidget> createState() => _DeadlineWidgetState();
}

class _DeadlineWidgetState extends State<DeadlineWidget> {
  final DateFormat formatter =
      DateFormat.yMMMMd('ru'); // TODO get system locale

  @override
  Widget build(BuildContext context) {
    bool showSelectedDate = (widget.deadline != -1);
    Brightness? brightness = MediaQuery.of(context).platformBrightness;
    String? formatted;
    if (showSelectedDate) {
      formatted = formatter.format(
        DateTime.fromMillisecondsSinceEpoch(widget.deadline * 1000),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: WidgetsSettings.smallScreenPadding,
        right: WidgetsSettings.smallScreenPadding,
        bottom: WidgetsSettings.bigScreenPadding,
      ),
      child: SwitchListTile(
        value: showSelectedDate,
        onChanged: (bool newState) async {
          if (newState == false) {
            setState(() {
              widget.deadline = -1;
            });
            return;
          }

          var deadline = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
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
          );
          if (deadline != null && deadline != widget.deadline) {
            setState(() {
              widget.deadline = deadline;
              widget.onSelected(deadline);
            });
          }
        },
        title: Text(
          AppLocalizations.of(context)!.deadline,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        subtitle: !showSelectedDate
            ? null
            : Text(
                formatted!,
                style: Theme.of(context).textTheme.caption!.copyWith(
                      color: brightness == Brightness.light
                          ? ToDoColors.blueLight
                          : ToDoColors.blueDark,
                    ),
              ),
      ),
    );
  }
}
