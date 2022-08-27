import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/business_logic/main_screen/bloc_for_main_screen.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/resources/app_icons.dart';

class DismissibleTask extends StatelessWidget {
  final Widget child;
  final Task task;
  const DismissibleTask({
    required this.child,
    required this.task,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;

    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      child: Dismissible(
        key: ValueKey(task.id),
        confirmDismiss: (DismissDirection direction) async {
          bool needDelete = false;
          if (direction == DismissDirection.startToEnd) {
            context
                .read<TasksMainScreenBloc>()
                .add(TaskCompletionToggled(task));
          } else if (direction == DismissDirection.endToStart) {
            context.read<TasksMainScreenBloc>().add(TaskFromListDeleted(task));
            needDelete = true;
          }

          // TODO придумать что-то, чтобы иконка менялась только после окончания анимации

          return needDelete;
        },
        background: DoneBackground(
          brightness: brightness,
          task: task,
        ),
        secondaryBackground: DeleteBackground(
          brightness: brightness,
        ),
        child: child,
      ),
    );
  }
}

class DeleteBackground extends StatelessWidget {
  const DeleteBackground({
    Key? key,
    required this.brightness,
  }) : super(key: key);

  final Brightness? brightness;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: brightness == Brightness.light
          ? ToDoColors.redLight
          : ToDoColors.redDark,
      alignment: Alignment.centerRight,
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: WidgetsSettings.mediumScreenPadding,
        ),
        child: AppIcon(
          path: IconResources.delete,
          color: ToDoColors.whiteLight,
        ),
      ),
    );
  }
}

class DoneBackground extends StatelessWidget {
  final Brightness? brightness;
  final Task task;

  const DoneBackground({
    required this.brightness,
    required this.task,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: brightness == Brightness.light
          ? ToDoColors.greenLight
          : ToDoColors.greenDark,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: WidgetsSettings.mediumScreenPadding,
        ),
        child: AppIcon(
          path: task.done ? IconResources.close : IconResources.check,
          color: ToDoColors.whiteLight,
        ),
      ),
    );
  }
}
