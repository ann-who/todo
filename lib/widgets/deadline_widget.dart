import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/resources/app_icons.dart';
import 'package:todo_app/widgets/app_button.dart';
import 'package:todo_app/widgets/calendar_widget.dart';

import '../resources/app_constants.dart';

class DeadlineWidget extends StatelessWidget {
  const DeadlineWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: WidgetsSettings.smallScreenPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.deadline,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          // TODO toggle button
          AppIconButton(
            () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CalendarWidget();
                },
              );
            },
            IconResources.switchOff,
          ),
        ],
      ),
    );
  }
}
