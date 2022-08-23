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
    return BlocConsumer<TasksMainScreenBloc, TasksMainScreenState>(
      listener: (context, state) async {
        if (state.status == TasksMainScreenStatus.onCreate) {
          Navigator.pushNamed(context, '/detailed').then((needUpdate) {
            var event = (needUpdate == true)
                ? const TasksListRefreshed()
                : const TaskEditCompleted();
            context.read<TasksMainScreenBloc>().add(event);
          });
        } else if (state.status == TasksMainScreenStatus.onEdit) {
          Navigator.pushNamed(
            context,
            '/detailed',
            arguments: state.taskOnEdition,
          ).then((needUpdate) {
            var event = (needUpdate == true)
                ? const TasksListRefreshed()
                : const TaskEditCompleted();
            context.read<TasksMainScreenBloc>().add(event);
          });
        } else if (state.status == TasksMainScreenStatus.failure) {
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
      builder: (context, state) => GestureDetector(
        onTap: () => _unfocus(context),
        child: WillPopScope(
          onWillPop: () async {
            _unfocus(context);
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () async => context
                .read<TasksMainScreenBloc>()
                .add(const TasksListRefreshed()),
            child: Scaffold(
              body: const CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  WideAppBarWidget(),
                  TasksListWidget(),
                ],
              ),
              floatingActionButton: state.fieldHasFocus
                  ? null
                  : FloatingActionButton(
                      onPressed: () => context
                          .read<TasksMainScreenBloc>()
                          .add(const TaskCreationOpened()),
                      child: const Icon(Icons.add),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _unfocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
