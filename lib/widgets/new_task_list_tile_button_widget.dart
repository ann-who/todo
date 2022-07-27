import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/resources/app_icons.dart';

import '../screens/task_detailed_screen.dart';

class NewTaskListTileButton extends StatelessWidget {
  const NewTaskListTileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const AppIcon(
        path: IconResources.add,
        color: Colors.transparent,
      ),
      title: Text(
        AppLocalizations.of(context)!.newToDo,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      // TODO incapsulate navigation
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TaskDetailedScreen()),
        );
      },
    );
  }
}
