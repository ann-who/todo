import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return BlocListener<TaskDetailedScreenBloc, TaskDetailedScreenState>(
      listener: (context, state) async {
        if (state.status == TaskDetailedScreenStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == TaskDetailedScreenStatus.failure) {
          await showDialog(
            context: context,
            builder: ((context) {
              // TODO handle errors
              String errorMessage;
              if (state.errorStatus == TaskDetailedScreenError.onCreateError) {
                errorMessage = 'Ошибочка...';
              } else if (state.errorStatus ==
                  TaskDetailedScreenError.onDeleteError) {
                errorMessage = 'Ошибочка...';
              } else {
                errorMessage = 'Странная ошибочка...';
              }
              return AlertDialog(
                content: Text(errorMessage),
              );
            }),
          );
          Navigator.of(context).pop(true);
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          final state = context.read<TaskDetailedScreenBloc>().state;
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
          return false; // pop будет после завершения
        },
        child: Scaffold(
          appBar: AppBar(
            leading: AppIconButton(
              iconPath: Icons.close,
              color: Theme.of(context).appBarTheme.iconTheme!.color,
              onPressed: () async {
                // TODO incapsulate navigation phase 2
                final state = context.read<TaskDetailedScreenBloc>().state;
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
                  // TODO gray
                  return AppTextButton(
                    value: AppLocalizations.of(context)!.save,
                    onPressed: !state.isChanged ||
                            state.status.isLoadingOrSuccess ||
                            state.taskText.isEmpty
                        ? null
                        : () {
                            context
                                .read<TaskDetailedScreenBloc>()
                                .add(const TaskSubmitted());
                          },
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
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.alertSaveTask),
        actions: [
          AppTextButton(
            value: AppLocalizations.of(context)!.save,
            onPressed: () => Navigator.of(context).pop(true),
          ),
          AppTextButton(
            value: AppLocalizations.of(context)!.exit,
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceEvenly,
      );
    },
  );

  if (isNeeded == null) {
    return NeedSaveAnswer.exitNotNeeded;
  } else if (isNeeded) {
    return NeedSaveAnswer.needed;
  }
  return NeedSaveAnswer.notNeeded;
}
