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
    final DateFormat formatter =
        DateFormat.yMMMMd(Localizations.localeOf(context).languageCode);

    return SizedBox.fromSize(
      child: deadline == -1
          ? null
          : Text(
              formatter.format(
                DateTime.fromMillisecondsSinceEpoch(deadline),
              ),
              style: Theme.of(context).textTheme.caption,
            ),
    );
  }
}
