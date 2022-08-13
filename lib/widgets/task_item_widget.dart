import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/resources/app_icons.dart';
import 'package:todo_app/screens/task_detailed_screen/task_detailed_screen.dart';

import 'package:todo_app/widgets/app_button.dart';

class TaskItemWidget extends StatefulWidget {
  final Task task;
  final Future<void> Function(bool?) onCheck;
  final ValueNotifier<bool> updateNotifier;

  const TaskItemWidget({
    required this.updateNotifier,
    required this.onCheck,
    required this.task,
    Key? key,
  }) : super(key: key);

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  Task? task;
  Importance _importance = Importance.basic;

  @override
  Widget build(BuildContext context) {
    _importance = widget.task.importance;
    bool? isChecked = widget.task.done;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        WidgetsSettings.listTileSmallPadding,
        WidgetsSettings.listTileVerticalPadding,
        WidgetsSettings.listTileSmallPadding,
        WidgetsSettings.listTileVerticalPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskCheckbox(
            isChecked: isChecked,
            widget: widget,
            importance: _importance,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.4,
            child: Transform.translate(
              offset: const Offset(
                WidgetsSettings.listTileSmallPadding,
                WidgetsSettings.noPadding,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: WidgetsSettings.listTileSmallPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaskPriorityIcon(
                          importance: _importance,
                        ),
                        TaskTitleText(
                          widget: widget,
                          isChecked: isChecked,
                        ),
                      ],
                    ),
                    TaskDeadlineSubtitle(
                      widget: widget,
                    ),
                  ],
                ),
              ),
            ),
          ),
          TaskTrailingIconButton(
            widget: widget,
          ),
        ],
      ),
    );
  }
}

class TaskTrailingIconButton extends StatelessWidget {
  const TaskTrailingIconButton({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final TaskItemWidget widget;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      onPressed: () async {
        bool? needUpdate = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailedScreen(
              initialTask: widget.task,
            ),
          ),
        );
        if (needUpdate == true) {
          widget.updateNotifier.value = !widget.updateNotifier.value;
        }
      },
      iconPath: Icons.info_outline,
      color: Theme.of(context).iconTheme.color,
    );
  }
}

class TaskDeadlineSubtitle extends StatelessWidget {
  const TaskDeadlineSubtitle({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final TaskItemWidget widget;

  @override
  Widget build(BuildContext context) {
    final String? formatted;
    // TODO get system locale
    final DateFormat formatter = DateFormat.yMMMMd('ru');
    return Container(
      child: widget.task.deadline == -1
          ? null
          : Text(
              formatted = formatter.format(
                DateTime.fromMillisecondsSinceEpoch(
                    widget.task.deadline * 1000),
              ),
              style: Theme.of(context).textTheme.caption,
            ),
    );
  }
}

class TaskTitleText extends StatelessWidget {
  const TaskTitleText({
    Key? key,
    required this.widget,
    required this.isChecked,
  }) : super(key: key);

  final TaskItemWidget widget;
  final bool? isChecked;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.6,
      child: Padding(
        padding: const EdgeInsets.only(
          top: WidgetsSettings.listTileSmallestPadding,
        ),
        child: Text(
          widget.task.text,
          style: TextStyle(
            decoration: isChecked == true
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: isChecked == true
                ? Theme.of(context).textTheme.subtitle1!.color
                : Theme.of(context).textTheme.bodyText1!.color,
            fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
            fontWeight: Theme.of(context).textTheme.bodyText1!.fontWeight,
          ),
          maxLines: WidgetsSettings.textTaskMaxHeight,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class TaskPriorityIcon extends StatelessWidget {
  const TaskPriorityIcon({
    Key? key,
    required Importance importance,
  })  : _importance = importance,
        super(key: key);

  final Importance _importance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: WidgetsSettings.listTileSmallestPadding,
      ),
      child: _importance == Importance.important
          ? AppIcon(
              path: IconResources.priorityHigh,
              color: _importance == Importance.important
                  ? ToDoColors.redLight
                  : ToDoColors.redDark,
            )
          : _importance == Importance.low
              ? AppIcon(
                  path: IconResources.priorityLow,
                  color: _importance == Importance.important
                      ? ToDoColors.grayLight
                      : ToDoColors.grayDark,
                )
              : Container(),
    );
  }
}

class TaskCheckbox extends StatelessWidget {
  const TaskCheckbox({
    Key? key,
    required this.isChecked,
    required this.widget,
    required Importance importance,
  })  : _importance = importance,
        super(key: key);

  final bool? isChecked;
  final TaskItemWidget widget;
  final Importance _importance;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: isChecked,
      onChanged: widget.onCheck,
      side: Theme.of(context).checkboxTheme.copyWith().side!.copyWith(
            color: _importance == Importance.important
                ? ToDoColors.redLight
                : ToDoColors.separatorLight,
          ),
    );
  }
}
