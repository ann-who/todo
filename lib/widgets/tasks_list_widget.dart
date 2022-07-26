import 'package:flutter/material.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/resources/app_icons.dart';
import 'package:todo_app/widgets/new_task_list_tile_button_widget.dart';
import 'package:todo_app/widgets/task_item_widget.dart';

class TasksListWidget extends StatefulWidget {
  const TasksListWidget({Key? key}) : super(key: key);

  @override
  State<TasksListWidget> createState() => _TasksListWidgetState();
}

class _TasksListWidgetState extends State<TasksListWidget> {
  List<int> items = List<int>.generate(15, (int index) => index);
  Brightness? brightness;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
        (context, index) {
          return Card(
            margin: const EdgeInsets.all(WidgetsSettings.smallestScreenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: ValueKey(items[index]),
                      onDismissed: (DismissDirection direction) {
                        setState(() {
                          items.removeAt(index);
                        });
                      },
                      background: Container(
                        color: brightness == Brightness.light
                            ? ToDoColors.greenLight
                            : ToDoColors.greenDark,
                        alignment: Alignment.centerLeft,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: WidgetsSettings.mediumScreenPadding,
                          ),
                          child: AppIcon(
                            path: IconResources.check,
                            color: ToDoColors.whiteLight,
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
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
                      ),
                      child: const TaskItemWidget(),
                    );
                  },
                ),
                const NewTaskListTileButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
