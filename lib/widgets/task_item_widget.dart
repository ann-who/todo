import 'package:flutter/material.dart';
import 'package:todo_app/resources/app_constants.dart';

import 'package:todo_app/resources/app_icons.dart';
import 'package:todo_app/widgets/app_button.dart';

class TaskItemWidget extends StatefulWidget {
  const TaskItemWidget({Key? key}) : super(key: key);

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  List<int>? tasks;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const AppIcon(path: IconResources.unchecked),
      title: Text(
        'Купить что-то',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: AppIconButton(
        () {},
        IconResources.infoOutline,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
