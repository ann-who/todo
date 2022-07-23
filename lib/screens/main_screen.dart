import 'package:flutter/material.dart';
import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/app_theme/text_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/resources/app_icons.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: AppLargeTitle(AppLocalizations.of(context)!.helloWorld)),
      // body: Padding(
      //   padding: const EdgeInsets.symmetric(
      //       horizontal: WidgetsSettings.smallestHorizontalPadding),
      //   child:
      body: Card(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return const ListTile(
              leading: AppIcon(path: IconResources.unchecked),
              title: AppBodyText('do something'),
              trailing: AppIcon(path: IconResources.infoOutline),
            );
          },
        ),
      ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const AppIcon(
          path: IconResources.add,
          color: ToDoColors.whiteLight,
        ),
      ),
    );
  }
}
