import 'package:flutter/material.dart';

import 'package:todo_app/data/repository/remote_task_repository.dart';
import 'package:todo_app/flavors/todo_config.dart';
import 'package:todo_app/todo_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Config.appFlavor = Flavor.prod;
  runApp(
    MyApp(
      taskRepository: RemoteTaskRepository(),
    ),
  );
}
