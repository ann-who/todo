// ignore_for_file: use_build_context_synchronously
// как понимаю, эта ошидка для statefull и ложно срабатывает

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/app_theme/app_colors.dart';

import 'package:todo_app/business_logic/task_detailed_screen/bloc_for_task_detailed_screen.dart';
import 'package:todo_app/presentation/widgets/buttons/app_icon_button.dart';
import 'package:todo_app/presentation/widgets/buttons/app_text_button.dart';
import 'package:todo_app/presentation/widgets/buttons/app_text_with_icon_button.dart';
import 'package:todo_app/presentation/widgets/buttons/priority_button.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/presentation/widgets/app_divider.dart';
import 'package:todo_app/presentation/widgets/deadline_widget.dart';
import 'package:todo_app/presentation/widgets/task_text_widget.dart';

class TaskDetailedPage extends StatelessWidget {
  const TaskDetailedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskDetailedScreenBloc, TaskDetailedScreenState>(
      listenWhen: (previous, current) =>
          previous.status == TaskDetailedScreenStatus.loading &&
          current.status.isResult,
      listener: (context, state) async {
        if (state.status == TaskDetailedScreenStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == TaskDetailedScreenStatus.failure) {
          await showDialog(
            context: context,
            builder: ((context) {
              String errorMessage;
              if (state.errorStatus == TaskDetailedScreenError.onCreateError) {
                errorMessage = AppLocalizations.of(context)!.onCreateError;
              } else if (state.errorStatus ==
                  TaskDetailedScreenError.onDeleteError) {
                errorMessage = AppLocalizations.of(context)!.onDeleteError;
              } else {
                errorMessage = AppLocalizations.of(context)!.errorOccured;
              }
              return AlertDialog(
                content: Text(errorMessage),
              );
            }),
          );
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) => WillPopScope(
        onWillPop: () async {
          if (!state.isChanged) {
            return true;
          }

          var isNeedSave = await isNeedSaveBeforeClose(context);
          if (isNeedSave == NeedSaveAnswer.exitNotNeeded) {
            return false;
          } else if (isNeedSave == NeedSaveAnswer.notNeeded) {
            return true;
          }

          context.read<TaskDetailedScreenBloc>().add(const TaskSubmitted());
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: AppIconButton(
              iconPath: Icons.close,
              color: Theme.of(context).appBarTheme.iconTheme!.color,
              onPressed: () async {
                if (!state.isChanged) {
                  Navigator.of(context).pop();
                  return;
                }

                var isNeedSave = await isNeedSaveBeforeClose(context);
                if (isNeedSave == NeedSaveAnswer.needed) {
                  context
                      .read<TaskDetailedScreenBloc>()
                      .add(const TaskSubmitted());
                  // pop будет после завершения
                } else if (isNeedSave == NeedSaveAnswer.notNeeded) {
                  Navigator.of(context).pop();
                }
              },
            ),
            actions: [
              BlocBuilder<TaskDetailedScreenBloc, TaskDetailedScreenState>(
                builder: (context, state) {
                  Brightness? brightness =
                      MediaQuery.of(context).platformBrightness;
                  return AppTextButton(
                    value: AppLocalizations.of(context)!.save,
                    onPressed: !state.isChanged ||
                            state.status.isLoadingOrSuccess ||
                            state.taskText.isEmpty
                        ? null
                        : () => context
                            .read<TaskDetailedScreenBloc>()
                            .add(const TaskSubmitted()),
                    color: (!state.isChanged ||
                            state.status.isLoadingOrSuccess ||
                            state.taskText.isEmpty)
                        ? (brightness == Brightness.light)
                            ? ToDoColors.labelDisableLight
                            : ToDoColors.labelDisableDark
                        : null,
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                TaskTextWidget(),
                AppPriorityPopupButton(),
                AppDivider(padding: WidgetsSettings.smallScreenPadding),
                DeadlineWidget(),
                AppDivider(),
                AppTextWithIconButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum NeedSaveAnswer { exitNotNeeded, needed, notNeeded }

Future<NeedSaveAnswer> isNeedSaveBeforeClose(BuildContext context) async {
  var isNeeded = await showDialog(
    context: context,
    builder: (BuildContext dialogContext) => BlocProvider.value(
      value: context.read<TaskDetailedScreenBloc>(),
      child: AlertDialog(
        title: Text(AppLocalizations.of(dialogContext)!.alertSaveTask),
        actions: [
          AppTextButton(
            value: AppLocalizations.of(dialogContext)!.save,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
          AppTextButton(
            value: AppLocalizations.of(dialogContext)!.exit,
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceEvenly,
      ),
    ),
  );

  if (isNeeded == null) {
    return NeedSaveAnswer.exitNotNeeded;
  } else if (isNeeded) {
    return NeedSaveAnswer.needed;
  }
  return NeedSaveAnswer.notNeeded;
}
