import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../resources/app_constants.dart';

class TaskTextWidget extends StatelessWidget {
  const TaskTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: WidgetsSettings.smallScreenPadding,
        left: WidgetsSettings.smallScreenPadding,
        top: WidgetsSettings.smallScreenPadding,
      ),
      child: Card(
        child: TextFormField(
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.haveToDo,
          ),
          maxLines: null,
          minLines: WidgetsSettings.textFieldMinHeight,
          textInputAction: TextInputAction.done,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
