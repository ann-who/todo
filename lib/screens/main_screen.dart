import 'package:flutter/material.dart';

import 'package:todo_app/app_theme/app_colors.dart';

import 'package:todo_app/resources/app_icons.dart';
import 'package:todo_app/screens/task_detailed_screen.dart';
import 'package:todo_app/widgets/wide_app_bar_widget.dart';
import 'package:todo_app/widgets/tasks_list_widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const CustomScrollView(
        slivers: <Widget>[
          ToDoAppBarWidget(),
          TasksListWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // TODO incapsulate navigation
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskDetailedScreen()),
          );
        },
        child: const AppIcon(
          path: IconResources.add,
          color: ToDoColors.whiteLight,
        ),
      ),
    );
  }
}
