import 'package:flutter/material.dart';
import 'package:todo_app/resources/app_constants.dart';

import 'package:todo_app/widgets/app_button.dart';

// TODO should it be a custom listTile?
class TaskItemWidget extends StatefulWidget {
  const TaskItemWidget({Key? key}) : super(key: key);

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  List<int>? tasks;
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        onChanged: (bool? value) {
          setState(() {
            isChecked = value;
          });
        },
        value: isChecked,
      ),
      title: Transform.translate(
        offset: const Offset(
          -WidgetsSettings.listTilePadding,
          WidgetsSettings.noPadding,
        ),
        child: Text(
          'Купить что-то ',
          style: isChecked == true
              ? Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(decoration: TextDecoration.lineThrough)
              : Theme.of(context).textTheme.bodyText1,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: AppIconButton(
        () {},
        Icons.info_outline,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
