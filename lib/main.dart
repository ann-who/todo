import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:todo_app/app_theme/theme_manager.dart';
import 'package:todo_app/data/repository/remote_task_repository.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/presentation/pages/main_screen.dart';

void main() {
  runApp(
    MyApp(
      taskRepository: RemoteTaskRepository(),
    ),
  );
}

var logger = Logger();

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required TaskRepository taskRepository,
  })  : _taskRepository = taskRepository,
        super(key: key);

  final TaskRepository _taskRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _taskRepository,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routes: {
          '/': (context) => const MainScreen(),
          // '/detailed': (context) => const TaskDetailedScreen(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeManager.theme(Brightness.light),
        darkTheme: ThemeManager.theme(Brightness.dark),
      ),
    );
  }
}
