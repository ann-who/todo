import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/data/repository/task_repository.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/widgets/app_button.dart';
import 'package:todo_app/resources/app_icons.dart';
import 'package:todo_app/widgets/app_divider.dart';
import 'package:todo_app/widgets/deadline_widget.dart';
import 'package:todo_app/widgets/task_text_widget.dart';

import '../models/task_model.dart';

class TaskDetailedScreen extends StatefulWidget {
  final Task? task;
  final ValueNotifier<bool> updateNotifier;

  const TaskDetailedScreen({
    required this.updateNotifier,
    this.task,
    Key? key,
  }) : super(key: key);

  @override
  State<TaskDetailedScreen> createState() => _TaskDetailedScreenState();
}

class _TaskDetailedScreenState extends State<TaskDetailedScreen> {
  final TextEditingController textFieldController = TextEditingController();
  Importance _importance = Importance.basic;
  int _deadline = -1;

  Map<Importance, String>? _convertImportanceToString;
  Map<String, Importance>? _convertStringToImportance;

  String importanceToString(Importance importance) {
    return _convertImportanceToString![importance]!;
  }

  Importance importanceFromString(String importance) {
    return _convertStringToImportance![importance]!;
  }

  @override
  Widget build(BuildContext context) {
    _convertImportanceToString ??= {
      Importance.basic: AppLocalizations.of(context)!.no,
      Importance.low: AppLocalizations.of(context)!.low,
      Importance.important: AppLocalizations.of(context)!.high,
    };
    _convertStringToImportance ??= {
      AppLocalizations.of(context)!.no: Importance.basic,
      AppLocalizations.of(context)!.low: Importance.low,
      AppLocalizations.of(context)!.high: Importance.important,
    };

    if (widget.task != null) {
      textFieldController.text = widget.task!.text;
      _importance = widget.task!.importance;
      _deadline = widget.task!.deadline;
    }

    return WillPopScope(
      onWillPop: () async {
        widget.task != null || textFieldController.text.isNotEmpty
            ? saveOrExit(context)
            : Navigator.of(context).pop();
        return Navigator.maybePop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppIconButton(
            // TODO incapsulate navigation phase 2
            onPressed: () {
              widget.task != null || textFieldController.text.isNotEmpty
                  ? saveOrExit(context)
                  : Navigator.of(context).pop();
            },
            iconPath: Icons.close,
            color: Theme.of(context).appBarTheme.iconTheme!.color,
          ),
          actions: [
            AppTextButton(
              onPressed: () async {
                if (textFieldController.text.isNotEmpty) {
                  {
                    if (widget.task == null) {
                      await createTask(context);
                    } else {
                      await updateTask(context);
                    }
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                }
              },
              value: AppLocalizations.of(context)!.save,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskTextWidget(
                task: widget.task,
                controller: textFieldController,
              ),
              AppPriorityPopupButton(
                  buttonTitle: AppLocalizations.of(context)!.priority,
                  selectedPriority: widget.task != null
                      ? importanceToString(widget.task!.importance)
                      : importanceToString(Importance.basic),
                  onSelected: (String importance) {
                    _importance = importanceFromString(importance);
                  }),
              const AppDivider(padding: WidgetsSettings.smallScreenPadding),
              DeadlineWidget(
                deadline:
                    widget.task != null ? widget.task!.deadline : _deadline,
                onSelected: (int deadline) {
                  _deadline = deadline;
                },
              ),
              const AppDivider(),
              AppTextWithIconButton(
                onPressed: widget.task == null
                    ? null
                    : () async {
                        await deleteTask(context);
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                value: AppLocalizations.of(context)!.delete,
                iconPath: IconResources.delete,
                color:
                    widget.task == null ? ToDoColors.labelDisableLight : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createTask(BuildContext context) async {
    var newTask = Task.full(
      text: textFieldController.text,
      importance: _importance,
      deadline: _deadline,
      done: false,
    );
    await context.read<TaskRepository>().createTask(newTask);
    widget.updateNotifier.value = !widget.updateNotifier.value;
  }

  Future<void> updateTask(BuildContext context) async {
    var updatedTask = widget.task!.copyWith(
      text: textFieldController.text,
      importance: _importance,
      deadline: _deadline,
      // other parameters
    );
    await context.read<TaskRepository>().updateTask(updatedTask);
    widget.updateNotifier.value = !widget.updateNotifier.value;
  }

  Future<void> deleteTask(BuildContext context) async {
    await context.read<TaskRepository>().deleteTask(widget.task!.id);
    widget.updateNotifier.value = !widget.updateNotifier.value;
  }

  saveOrExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.alertSaveTask,
          ),
          actions: [
            AppTextButton(
              onPressed: () async {
                if (widget.task == null) {
                  await createTask(context);
                } else {
                  await updateTask(context);
                }

                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              value: AppLocalizations.of(context)!.save,
            ),
            AppTextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              value: AppLocalizations.of(context)!.exit,
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
        );
      },
    );
  }
}
