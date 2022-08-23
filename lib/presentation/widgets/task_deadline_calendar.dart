import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/presentation/widgets/buttons/app_text_button.dart';
import 'package:todo_app/resources/app_constants.dart';

class TaskDeadlineCalendar extends StatefulWidget {
  const TaskDeadlineCalendar({
    super.key,
  });

  @override
  State<TaskDeadlineCalendar> createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TaskDeadlineCalendar> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final DateFormat formattedWeekday =
        DateFormat.E(Localizations.localeOf(context).languageCode);
    final DateFormat formattedMonth =
        DateFormat.MMMM(Localizations.localeOf(context).languageCode);

    Brightness? brightness = MediaQuery.of(context).platformBrightness;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox.fromSize(
          child: Column(
            children: [
              CalendarHeader(
                  brightness: brightness,
                  focusedDay: _focusedDay,
                  formattedWeekday: formattedWeekday,
                  formattedMonth: formattedMonth),
              TableCalendar(
                locale: Localizations.localeOf(context).languageCode,
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 36500)),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextStyle: Theme.of(context).textTheme.button!.copyWith(
                        color: brightness == Brightness.light
                            ? ToDoColors.labelPrimaryLight
                            : ToDoColors.labelPrimaryDark,
                      ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: brightness == Brightness.light
                        ? ToDoColors.labelTertiaryLight
                        : ToDoColors.labelTertiaryDark,
                  ),
                  weekendStyle: TextStyle(
                    color: brightness == Brightness.light
                        ? ToDoColors.labelTertiaryLight
                        : ToDoColors.labelTertiaryDark,
                  ),
                ),
                availableGestures: AvailableGestures.horizontalSwipe,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: TextStyle(
                    color: brightness == Brightness.light
                        ? ToDoColors.labelPrimaryLight
                        : ToDoColors.labelPrimaryDark,
                  ),
                  todayDecoration: BoxDecoration(
                    color: brightness == Brightness.light
                        ? ToDoColors.blueLight.withOpacity(0.3)
                        : ToDoColors.blueDark.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: brightness == Brightness.light
                        ? ToDoColors.blueLight
                        : ToDoColors.blueDark,
                    shape: BoxShape.circle,
                  ),
                ),
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              CalendarButtons(selectedDay: _selectedDay),
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarButtons extends StatelessWidget {
  const CalendarButtons({
    Key? key,
    required DateTime? selectedDay,
  })  : _selectedDay = selectedDay,
        super(key: key);

  final DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppTextButton(
          onPressed: () => Navigator.of(context).pop(),
          value: AppLocalizations.of(context)!.cancel,
        ),
        AppTextButton(
          onPressed: () => _selectedDay != null
              ? Navigator.of(context)
                  .pop(_selectedDay!.millisecondsSinceEpoch ~/ 1000)
              : Navigator.of(context).pop(),
          value: AppLocalizations.of(context)!.ok,
        ),
      ],
    );
  }
}

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    Key? key,
    required this.brightness,
    required DateTime focusedDay,
    required this.formattedWeekday,
    required this.formattedMonth,
  })  : _focusedDay = focusedDay,
        super(key: key);

  final Brightness? brightness;
  final DateTime _focusedDay;
  final DateFormat formattedWeekday;
  final DateFormat formattedMonth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (MediaQuery.of(context).orientation == Orientation.portrait)
          ? MediaQuery.of(context).size.height / 8
          : MediaQuery.of(context).size.height / 4,
      width: double.infinity,
      child: SizedBox.shrink(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: brightness == Brightness.light
                ? ToDoColors.blueLight
                : ToDoColors.blueDark,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: WidgetsSettings.wideAppBarMediumPadding,
              vertical: WidgetsSettings.wideAppBarSmallPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_focusedDay.year}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: ToDoColors.whiteLight),
                ),
                Text(
                  '${formattedWeekday.format(_focusedDay)}, ${formattedMonth.format(_focusedDay)} ${_focusedDay.day} ',
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: ToDoColors.whiteLight),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
