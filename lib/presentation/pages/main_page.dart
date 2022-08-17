import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/business_logic/main_screen/bloc_for_main_screen.dart';
import 'package:todo_app/presentation/pages/task_detailed_screen.dart';
import 'package:todo_app/presentation/widgets/tasks_list/tasks_list_widget.dart';
import 'package:todo_app/presentation/widgets/wide_app_bar_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksMainScreenBloc, TasksMainScreenState>(
      listener: (context, state) async {
        if (state.status == TasksMainScreenStatus.failure) {
          await showDialog(
            context: context,
            builder: ((context) {
              String errorMessage;
              switch (state.errorStatus) {
                case TasksMainScreenError.none:
                  errorMessage = 'Нет ошибочки...';
                  break;
                case TasksMainScreenError.onCreateError:
                  errorMessage = 'Ошибочка при создании...';
                  break;
                case TasksMainScreenError.onDeleteError:
                  errorMessage = 'Ошибочка при удалении...';
                  break;
                case TasksMainScreenError.onUpdateError:
                  errorMessage = 'Ошибочка при изменении...';
                  break;
                case TasksMainScreenError.onRefreshError:
                  errorMessage = 'Ошибочка при обновлении...';
                  break;
              }

              return AlertDialog(
                content: Text(errorMessage),
              );
            }),
          );
        }
      },
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: RefreshIndicator(
          onRefresh: () {
            context.read<TasksMainScreenBloc>().add(const TasksListRefreshed());
            return Future.value();
          },
          child: Scaffold(
            body: const CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                WideAppBarWidget(),
                TasksListWidget(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              // TODO incapsulate navigation
              onPressed: () async {
                bool? needUpdate = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskDetailedScreen(),
                  ),
                );
                if (needUpdate == true) {
                  context
                      .read<TasksMainScreenBloc>()
                      .add(const TasksListRefreshed());
                }
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
