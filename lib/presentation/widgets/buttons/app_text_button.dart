import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/business_logic/task_detailed_screen/bloc_for_task_detailed_screen.dart';

class AppTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String value;
  final Color? color;

  const AppTextButton({
    required this.onPressed,
    required this.value,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness? brightness = MediaQuery.of(context).platformBrightness;
    var enabledColor = (brightness == Brightness.light)
        ? ToDoColors.blueLight
        : ToDoColors.blueDark;

    return BlocBuilder<TaskDetailedScreenBloc, TaskDetailedScreenState>(
      builder: (context, state) {
        return TextButton(
          onPressed: onPressed,
          child: Text(
            value.toUpperCase(),
            style: Theme.of(context).textTheme.button!.copyWith(
                  color: color ?? enabledColor,
                ),
          ),
        );
      },
    );
  }
}
