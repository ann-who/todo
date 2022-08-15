import 'package:flutter/material.dart';
import 'package:todo_app/resources/app_constants.dart';

class AppDivider extends StatelessWidget {
  final double padding;

  const AppDivider({
    Key? key,
    this.padding = WidgetsSettings.noPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: const Divider(
        height: WidgetsSettings.dividerHeight,
      ),
    );
  }
}
