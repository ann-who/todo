import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/widgets/app_button.dart';
import 'package:todo_app/resources/app_icons.dart';
import 'package:todo_app/widgets/deadline_widget.dart';
import 'package:todo_app/widgets/task_text_widget.dart';

class TaskDetailedScreen extends StatelessWidget {
  const TaskDetailedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppIconButton(
          // TODO incapsulate navigation
          () {
            Navigator.pop(context);
          },
          IconResources.close,
          // TODO move to buttons class
          color: ToDoColors.labelPrimaryLight,
        ),
        actions: [
          AppTextButton(() {}, AppLocalizations.of(context)!.save),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TaskTextWidget(),
            const SizedBox(
              height: WidgetsSettings.bigScreenPadding,
            ),
            AppPriorityPopupButton(
              buttonTitle: AppLocalizations.of(context)!.priority,
            ),
            const SizedBox(
              height: WidgetsSettings.smallScreenPadding,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: WidgetsSettings.smallScreenPadding),
              child: Divider(
                height: WidgetsSettings.dividerHeight,
              ),
            ),
            const SizedBox(
              height: WidgetsSettings.bigScreenPadding,
            ),
            const DeadlineWidget(),
            const SizedBox(
              height: WidgetsSettings.biggestScreenPadding,
            ),
            const Divider(
              height: WidgetsSettings.dividerHeight,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: WidgetsSettings.smallScreenPadding),
              child: AppTextWithIconButton(
                () {},
                AppLocalizations.of(context)!.delete,
                IconResources.delete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
