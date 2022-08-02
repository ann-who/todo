import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      // TODO implement calendar (see table_calendar package)
      title: Text('Calendar is on vacations'),
      children: [
        SizedBox(
          height: 200,
          width: 100,
          child: Container(color: Colors.cyan),
        ),
      ],
    );
  }
}
