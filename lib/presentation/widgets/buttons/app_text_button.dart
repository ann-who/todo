import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/business_logic/task_detailed_screen/bloc_for_task_detailed_screen.dart';

class AppTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String value;

  const AppTextButton({
    required this.onPressed,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness? brightness = MediaQuery.of(context).platformBrightness;
    var enabledColor = (brightness == Brightness.light)
        ? ToDoColors.blueLight
        : ToDoColors.blueDark;
    var disabledColor = (brightness == Brightness.light)
        ? ToDoColors.labelDisableLight
        : ToDoColors.labelDisableDark;

    return BlocBuilder<TaskDetailedScreenBloc, TaskDetailedScreenState>(
      builder: (context, state) {
        return TextButton(
          onPressed: onPressed,
          child: Text(
            value.toUpperCase(),
            style: Theme.of(context).textTheme.button!.copyWith(
                  color: !state.isChanged ||
                          state.status.isLoadingOrSuccess ||
                          state.taskText.isEmpty
                      ? disabledColor
                      : enabledColor,
                ),
          ),
        );
      },
    );
  }
}
