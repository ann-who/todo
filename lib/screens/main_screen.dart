import 'package:flutter/material.dart';
import 'package:todo_app/data/repository/remote_task_repository.dart';
import 'package:todo_app/data/repository/task_repository.dart';

import 'package:todo_app/screens/task_detailed_screen.dart';
import 'package:todo_app/widgets/wide_app_bar_widget.dart';
import 'package:todo_app/widgets/tasks_list_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ValueNotifier<int> _completedCounter = ValueNotifier<int>(0);
  final ValueNotifier<bool> _onlyUndoneVisible = ValueNotifier<bool>(false);

  //! NEEDHELP это костыль, чтобы вызвать обновление, но лучше не придумала
  final ValueNotifier<bool> _updateNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: RefreshIndicator(
        onRefresh: () {
          _updateNotifier.value = !_updateNotifier.value;
          return Future.value(); // Зачем возвращать значение?
        },
        child: Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              WideAppBarWidget(
                completedCounter: _completedCounter,
                onlyUndoneVisible: _onlyUndoneVisible,
              ),
              TasksListWidget(
                completedCounter: _completedCounter,
                onlyUndoneVisible: _onlyUndoneVisible,
                updateNotifier: _updateNotifier,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            // TODO incapsulate navigation
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailedScreen(
                    updateNotifier: _updateNotifier,
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
