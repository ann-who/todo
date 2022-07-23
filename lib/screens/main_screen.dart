import 'package:flutter/material.dart';
import 'package:todo_app/app_theme/text_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: AppLargeTitle(AppLocalizations.of(context)!.helloWorld)),
      body: Text(AppLocalizations.of(context)!.title),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }
}
