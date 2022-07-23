import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppLargeTitle extends StatelessWidget {
  static const fontSize = 32.0;

  final String value;

  const AppLargeTitle(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: ToDoColors.labelPrimaryLight,
      ),
    );
  }
}

class AppTitle extends StatelessWidget {
  static const fontSize = 20.0;

  final String value;

  const AppTitle(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: ToDoColors.labelPrimaryLight,
      ),
    );
  }
}

class AppBodyText extends StatelessWidget {
  static const fontSize = 16.0;

  final String value;

  const AppBodyText(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class AppButtonText extends StatelessWidget {
  static const fontSize = 14.0;

  final String value;

  const AppButtonText(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class AppSubheadText extends StatelessWidget {
  static const fontSize = 14.0;

  final String value;

  const AppSubheadText(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
