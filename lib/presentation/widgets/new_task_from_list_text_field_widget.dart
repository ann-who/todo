import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:todo_app/resources/app_constants.dart';

class NewTaskFromListTextField extends StatefulWidget {
  final Future<void> Function(String message) onSubmit;

  const NewTaskFromListTextField({
    required this.onSubmit,
    Key? key,
  }) : super(key: key);

  @override
  State<NewTaskFromListTextField> createState() =>
      _NewTaskFromListTextFieldState();
}

class _NewTaskFromListTextFieldState extends State<NewTaskFromListTextField> {
  TextEditingController controller = TextEditingController();
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: WidgetsSettings.textFieldPadding,
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.newToDo,
        ),
        style: Theme.of(context).textTheme.bodyText1,
        maxLines: null,
        textInputAction: TextInputAction.done,
        enabled: _enabled,
        onFieldSubmitted: (value) async {
          if (value.isNotEmpty) {
            setState(() {
              _enabled = false;
            });
            await widget.onSubmit(value);
            controller.clear();
            setState(() {
              _enabled = true;
            });
          }
        },
      ),
    );
  }
}
