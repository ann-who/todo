import 'package:flutter/material.dart';

import 'package:todo_app/resources/app_constants.dart';

class TaskTitleText extends StatelessWidget {
  const TaskTitleText({
    required this.text,
    required this.isChecked,
    Key? key,
  }) : super(key: key);

  final String text;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.6,
      child: Padding(
        padding: const EdgeInsets.only(
          top: WidgetsSettings.listTileSmallestPadding,
        ),
        child: Text(
          text,
          style: TextStyle(
            decoration:
                isChecked ? TextDecoration.lineThrough : TextDecoration.none,
            color: isChecked
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
