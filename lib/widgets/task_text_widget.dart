import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/models/task_model.dart';

import '../resources/app_constants.dart';

class TaskTextWidget extends StatefulWidget {
  final Task? task;
  final TextEditingController controller;

  const TaskTextWidget({
    required this.task,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<TaskTextWidget> createState() => _TaskTextWidgetState();
}

class _TaskTextWidgetState extends State<TaskTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        WidgetsSettings.smallScreenPadding,
        WidgetsSettings.smallScreenPadding,
        WidgetsSettings.smallScreenPadding,
        WidgetsSettings.bigScreenPadding,
      ),
      child: Card(
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.haveToDo,
          ),
          maxLines: null,
          minLines: WidgetsSettings.textFieldMinHeight,
          textInputAction: TextInputAction.done,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
