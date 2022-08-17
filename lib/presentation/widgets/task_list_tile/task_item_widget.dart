import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/business_logic/main_screen/bloc_for_main_screen.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/presentation/widgets/task_list_tile/leading_checkbox.dart';
import 'package:todo_app/presentation/widgets/task_list_tile/priority_icon.dart';
import 'package:todo_app/presentation/widgets/task_list_tile/task_deadline_subtitle.dart';
import 'package:todo_app/presentation/widgets/task_list_tile/task_title.dart';
import 'package:todo_app/presentation/widgets/task_list_tile/trailing_icon_button.dart';
import 'package:todo_app/resources/app_constants.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;

  const TaskItemWidget({
    required this.task,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        WidgetsSettings.listTileSmallPadding,
        WidgetsSettings.listTileVerticalPadding,
        WidgetsSettings.listTileSmallPadding,
        WidgetsSettings.listTileVerticalPadding,
      ),
      child: SizedBox(
        width: double.maxFinite,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<TasksMainScreenBloc, TasksMainScreenState>(
              builder: (context, state) {
                return TaskCheckbox(
                  isChecked: task.done,
                  importance: task.importance,
                  onChanged: (_) {
                    context
                        .read<TasksMainScreenBloc>()
                        .add(TaskCompletionToggled(task));
                  },
                );
              },
            ),
            Expanded(
              child: Transform.translate(
                offset: const Offset(
                  WidgetsSettings.listTileSmallPadding,
                  WidgetsSettings.noPadding,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: WidgetsSettings.listTileSmallPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TaskPriorityIcon(importance: task.importance),
                          TaskTitleText(
                            text: task.text,
                            isChecked: task.done,
                          ),
                        ],
                      ),
                      TaskDeadlineSubtitle(deadline: task.deadline),
                    ],
                  ),
                ),
              ),
            ),
            TaskTrailingIconButton(
              initialTask: task,
            ),
          ],
        ),
      ),
    );
  }
}
