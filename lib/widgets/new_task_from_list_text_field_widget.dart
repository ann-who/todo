import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../resources/app_constants.dart';

class NewTaskFromListTextField extends StatefulWidget {
  const NewTaskFromListTextField({Key? key}) : super(key: key);

  @override
  State<NewTaskFromListTextField> createState() =>
      _NewTaskFromListTextFieldState();
}

class _NewTaskFromListTextFieldState extends State<NewTaskFromListTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: WidgetsSettings.textFieldPadding,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.newToDo,
        ),
        style: Theme.of(context).textTheme.bodyText1,
        maxLines: null,
        textInputAction: TextInputAction.done,
        // autofocus: false,
      ),
    );
  }
}
