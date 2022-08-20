import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/business_logic/main_screen/bloc_for_main_screen.dart';
import 'package:todo_app/resources/app_constants.dart';

class NewTaskFromListTextField extends StatelessWidget {
  const NewTaskFromListTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: WidgetsSettings.textFieldPadding,
      ),
      child: BlocBuilder<TasksMainScreenBloc, TasksMainScreenState>(
        builder: (context, state) {
          return Focus(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.newToDo,
              ),
              style: Theme.of(context).textTheme.bodyText1,
              maxLines: null,
              textInputAction: TextInputAction.done,
              enabled: !state.status.isBusy,
              onChanged: (taskText) => context
                  .read<TasksMainScreenBloc>()
                  .add(TaskTextChanged(taskText)),
              onFieldSubmitted: (value) {
                if (value.isEmpty) {
                  return;
                }
                context.read<TasksMainScreenBloc>().add(const TaskSubmitted());
                controller.clear();
              },
            ),
            onFocusChange: (hasFocus) => context
                .read<TasksMainScreenBloc>()
                .add(TaskFieldFocusChanged(hasFocus)),
          );
        },
      ),
    );
  }
}
