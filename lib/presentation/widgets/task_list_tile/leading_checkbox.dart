import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/business_logic/main_screen/bloc_for_main_screen.dart';
import 'package:todo_app/models/task_model.dart';

class TaskCheckbox extends StatelessWidget {
  const TaskCheckbox({
    required this.isChecked,
    required this.importance,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final bool isChecked;
  final Importance importance;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    Brightness? brightness = MediaQuery.of(context).platformBrightness;
    var importantColor = (brightness == Brightness.light)
        ? ToDoColors.redLight
        : ToDoColors.redDark;
    var basicColor = (brightness == Brightness.light)
        ? ToDoColors.separatorLight
        : ToDoColors.separatorDark;

    return BlocBuilder<TasksMainScreenBloc, TasksMainScreenState>(
      builder: (context, state) {
        return Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: isChecked,
          onChanged: onChanged,
          side: Theme.of(context).checkboxTheme.side!.copyWith(
                color: importance == Importance.basic ||
                        importance == Importance.low
                    ? basicColor
                    : importantColor,
              ),
        );
      },
    );
  }
}
