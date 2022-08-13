import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/screens/task_detailed_screen/bloc/task_detailed_screen_bloc.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/screens/task_detailed_screen/bloc/task_detailed_screen_event.dart';

class TaskTextWidget extends StatelessWidget {
  const TaskTextWidget({
    Key? key,
  }) : super(key: key);

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
          initialValue: context.read<TaskDetailedScreenBloc>().state.taskText,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.haveToDo,
          ),
          maxLines: null,
          minLines: WidgetsSettings.textFieldMinHeight,
          textInputAction: TextInputAction.done,
          style: Theme.of(context).textTheme.bodyText1,
          onChanged: (value) => context
              .read<TaskDetailedScreenBloc>()
              .add(TaskTextChanged(value)),
        ),
      ),
    );
  }
}
