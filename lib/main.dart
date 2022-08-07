import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/app_theme/theme_manager.dart';
import 'package:todo_app/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

var logger = Logger();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: {
        '/main': (context) => const MainScreen(),
        // '/detailed': (context) => const TaskDetailedScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeManager.theme(Brightness.light),
      darkTheme: ThemeManager.theme(Brightness.dark),
      home: const MainScreen(),
    );
  }
}
