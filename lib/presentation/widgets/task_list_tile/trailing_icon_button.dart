import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/business_logic/main_screen/bloc_for_main_screen.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/presentation/pages/task_detailed_screen.dart';
import 'package:todo_app/presentation/widgets/buttons/app_icon_button.dart';

class TaskTrailingIconButton extends StatelessWidget {
  const TaskTrailingIconButton({
    required this.initialTask,
    Key? key,
  }) : super(key: key);

  final Task initialTask;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      onPressed: () async {
        bool? needUpdate = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailedScreen(
              initialTask: initialTask,
            ),
          ),
        );
        if (needUpdate == true) {
          context.read<TasksMainScreenBloc>().add(const TasksListRefreshed());
        }
      },
      iconPath: Icons.info_outline,
      color: Theme.of(context).iconTheme.color,
    );
  }
}
