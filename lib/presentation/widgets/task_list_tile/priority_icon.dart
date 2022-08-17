import 'package:flutter/material.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/resources/app_icons.dart';

class TaskPriorityIcon extends StatelessWidget {
  const TaskPriorityIcon({
    required this.importance,
    Key? key,
  }) : super(key: key);

  final Importance importance;

  @override
  Widget build(BuildContext context) {
    Brightness? brightness = MediaQuery.of(context).platformBrightness;
    var importantColor = (brightness == Brightness.light)
        ? ToDoColors.redLight
        : ToDoColors.redDark;
    var lowColor = (brightness == Brightness.light)
        ? ToDoColors.grayLight
        : ToDoColors.grayDark;

    return Container(
      padding: const EdgeInsets.only(
        top: WidgetsSettings.listTileSmallestPadding,
        right: WidgetsSettings.listTileSmallestPadding,
      ),
      child: importance == Importance.basic
          ? Container()
          : AppIcon(
              path: importance == Importance.important
                  ? IconResources.priorityHigh
                  : IconResources.priorityLow,
              color: importance == Importance.important
                  ? importantColor
                  : lowColor,
            ),
    );
  }
}
