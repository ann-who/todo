import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/business_logic/task_detailed_screen/bloc/task_detailed_screen_bloc.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/presentation/pages/task_detailed_page.dart';

class TaskDetailedScreen extends StatelessWidget {
  final Task? initialTask;

  const TaskDetailedScreen({
    this.initialTask,
    Key? key,
  }) : super(key: key);

  static const routeName = '/detailed';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskDetailedScreenBloc(
        taskRepository: context.read<TaskRepository>(),
        initialTask: initialTask,
      ),
      child: const TaskDetailedPage(),
    );
  }
}
