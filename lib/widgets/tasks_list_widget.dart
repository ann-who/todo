import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/data/network/task_data_source.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/resources/app_icons.dart';
import 'package:todo_app/widgets/new_task_from_list_text_field_widget.dart';
import 'package:todo_app/widgets/task_item_widget.dart';

class TasksListWidget extends StatefulWidget {
  final ValueNotifier<int> completedCounter;
  final ValueNotifier<bool> onlyUndoneVisible;
  final ValueNotifier<bool> updateNotifier;

  const TasksListWidget({
    Key? key,
    required this.completedCounter,
    required this.onlyUndoneVisible,
    required this.updateNotifier,
  }) : super(key: key);

  @override
  State<TasksListWidget> createState() => _TasksListWidgetState();
}

class _TasksListWidgetState extends State<TasksListWidget> {
  Brightness? brightness;
  Future<List<Task>>? tasksList;
  Task? task;

  @override
  void initState() {
    super.initState();
    widget.updateNotifier.addListener(updateTasks);
    widget.onlyUndoneVisible.addListener(() {
      setState(() {});
    });
    updateTasks();
  }

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
              child: FutureBuilder(
                future: tasksList,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return loadingWidget;
                  }
                  if (snapshot.hasError) {
                    return errorWidget;
                  }
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  List<Task> visibleTasks;
                  if (widget.onlyUndoneVisible.value) {
                    visibleTasks =
                        snapshot.data.where((task) => !task.done).toList();
                  } else {
                    visibleTasks = snapshot.data.toList();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: visibleTasks.length,
                        itemBuilder: (BuildContext context, int index) {
                          var task = visibleTasks[index];

                          return ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            child: Dismissible(
                              key: ValueKey(task.id),
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                bool needDelete = false;
                                if (direction == DismissDirection.startToEnd) {
                                  var updatedTask = await toggleTask(task);
                                  if (updatedTask != null) {
                                    int indexInFullList = snapshot.data
                                        .indexWhere(
                                            (t) => t.id == updatedTask.id);
                                    visibleTasks[index] = updatedTask;
                                    snapshot.data[indexInFullList] =
                                        updatedTask;
                                  }
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  await deleteTask(task);
                                  int indexInFullList = snapshot.data
                                      .indexWhere((t) => t.id == task.id);
                                  visibleTasks.removeAt(index);
                                  snapshot.data.removeAt(indexInFullList);
                                  needDelete = true;
                                }
                                // TODO придумать что-то, чтобы иконка менялась после окончания анимации
                                setState(() {});
                                return needDelete;
                              },
                              background: DoneBackground(
                                brightness: brightness,
                                task: task,
                              ),
                              secondaryBackground: DeleteBackground(
                                brightness: brightness,
                              ),
                              child: TaskItemWidget(
                                onCheck: (bool? checked) async {
                                  var updatedTask = await toggleTask(task);
                                  if (updatedTask == null) {
                                    return;
                                  }

                                  int indexInFullList = snapshot.data
                                      .indexWhere(
                                          (t) => t.id == updatedTask.id);
                                  visibleTasks[index] = updatedTask;
                                  snapshot.data[indexInFullList] = updatedTask;
                                  setState(() {});
                                },
                                task: task,
                                // repository: widget.repository,
                                updateNotifier: widget.updateNotifier,
                              ),
                            ),
                          );
                        },
                      ),
                      NewTaskFromListTextField(
                        onSubmit: (String message) async {
                          var newTask = await createTask(message);
                          if (newTask == null) {
                            return;
                          }
                          snapshot.data.add(newTask);
                          setState(() {});
                        },
                      ),
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

  Future<void> updateTasks() async {
    tasksList = context.read<TaskRepository>().getTasksList();
    tasksList!.then((list) {
      int countDone = 0;
      for (var task in list) {
        if (task.done) ++countDone;
      }
      widget.completedCounter.value = countDone;
    });
    setState(() {});
  }

  Future<Task?> createTask(String message) async {
    try {
      var newTask = Task.minimal(message);
      await context.read<TaskRepository>().createTask(newTask);

      if (context.read<TaskRepository>().needRefresh()) {
        updateTasks();
      }

      return newTask;
    } on TaskDSException catch (e) {
      showError(e.message);
    }

    return null;
  }

  Future<Task?> toggleTask(Task task) async {
    try {
      var updatedTask = task.copyWith(done: !task.done);
      await context.read<TaskRepository>().updateTask(updatedTask);

      widget.completedCounter.value += updatedTask.done ? 1 : -1;

      if (context.read<TaskRepository>().needRefresh()) {
        updateTasks();
      }

      return updatedTask;
    } on NotFoundException {
      showError(AppLocalizations.of(context)!.alreadyDeletedError);
    } on TaskDSException catch (e) {
      showError(e.message);
    }

    return null;
  }

  Future<void> deleteTask(Task task) async {
    try {
      await context.read<TaskRepository>().deleteTask(task.id);
      if (task.done) {
        --widget.completedCounter.value;
      }
      if (context.read<TaskRepository>().needRefresh()) {
        updateTasks();
      }
    } on NotFoundException {
      showError(AppLocalizations.of(context)!.alreadyDeletedError);
    } on TaskDSException catch (e) {
      showError(e.message);
    }
  }

  Future<void> showError(String message) {
    return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          content: Text(message),
        );
      }),
    );
  }

  Widget get loadingWidget => const Padding(
        padding: EdgeInsets.all(WidgetsSettings.bigScreenPadding),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );

  Widget get errorWidget => Padding(
        padding: const EdgeInsets.all(WidgetsSettings.bigScreenPadding),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.errorOccured,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      );
}

class DeleteBackground extends StatelessWidget {
  const DeleteBackground({
    Key? key,
    required this.brightness,
  }) : super(key: key);

  final Brightness? brightness;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: brightness == Brightness.light
          ? ToDoColors.redLight
          : ToDoColors.redDark,
      alignment: Alignment.centerRight,
      child: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: WidgetsSettings.mediumScreenPadding,
        ),
        child: AppIcon(
          path: IconResources.delete,
          color: ToDoColors.whiteLight,
        ),
      ),
    );
  }
}

class DoneBackground extends StatelessWidget {
  const DoneBackground({
    Key? key,
    required this.brightness,
    required this.task,
  }) : super(key: key);

  final Brightness? brightness;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: brightness == Brightness.light
          ? ToDoColors.greenLight
          : ToDoColors.greenDark,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: WidgetsSettings.mediumScreenPadding,
        ),
        child: AppIcon(
          path: task.done ? IconResources.close : IconResources.check,
          color: ToDoColors.whiteLight,
        ),
      ),
    );
  }
}
