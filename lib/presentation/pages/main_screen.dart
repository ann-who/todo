import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/business_logic/main_screen/bloc/main_screen_bloc.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/flavors/todo_config.dart';
import 'package:todo_app/presentation/pages/main_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksMainScreenBloc(
        taskRepository: context.read<TaskRepository>(),
      )..add(
          const TasksListRefreshed(),
        ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          const MainPage(),
          Config.flavorBanner,
        ],
      ),
    );
  }
}
