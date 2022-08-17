import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class TaskDeadlineSubtitle extends StatelessWidget {
  const TaskDeadlineSubtitle({
    required this.deadline,
    Key? key,
  }) : super(key: key);

  final int deadline;

  @override
  Widget build(BuildContext context) {
    // TODO get system locale
    final DateFormat formatter = DateFormat.yMMMMd('ru');
    return Container(
      child: deadline == -1
          ? null
          : Text(
              formatter.format(
                DateTime.fromMillisecondsSinceEpoch(deadline * 1000),
              ),
              style: Theme.of(context).textTheme.caption,
            ),
    );
  }
}
