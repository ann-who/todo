import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:todo_app/business_logic/main_screen/bloc_for_main_screen.dart';
import 'package:todo_app/presentation/widgets/task_list_tile/task_item_widget.dart';
import 'package:todo_app/presentation/widgets/tasks_list/new_task_from_list_text_field_widget.dart';
import 'package:todo_app/presentation/widgets/tasks_list/task_dismissible.dart';
import 'package:todo_app/resources/app_constants.dart';

class TasksListWidget extends StatelessWidget {
  const TasksListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
        (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              top: WidgetsSettings.smallScreenPadding,
            ),
            child: Card(
              margin: const EdgeInsets.all(
                WidgetsSettings.smallestScreenPadding,
              ),
              child: BlocBuilder<TasksMainScreenBloc, TasksMainScreenState>(
                builder: (context, state) {
                  if (state.status == TasksMainScreenStatus.loading) {
                    return const LoadingWidget();
                  } else if (state.status == TasksMainScreenStatus.failure) {
                    return const ErrorWidget();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.filteredTasks.length,
                        itemBuilder: (BuildContext context, int index) {
                          var task = state.filteredTasks.toList()[index];
                          return DismissibleTask(
                            task: task,
                            child: TaskItemWidget(
                              task: task,
                            ),
                          );
                        },
                      ),
                      const NewTaskFromListTextField(),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: WidgetsSettings.bigScreenPadding),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: WidgetsSettings.bigScreenPadding),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.errorOccured,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
