import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/presentation/widgets/buttons/app_text_button.dart';

import '../test/data/repository/fake_task_repository.dart';
import 'package:todo_app/flavors/todo_config.dart';

import 'package:todo_app/todo_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Config.appFlavor = Flavor.dev;
  group(
    'Task creation by using the FAB',
    () {
      testWidgets('Find and tap the FAB', (WidgetTester tester) async {
        await tester.pumpWidget(
          MyApp(taskRepository: FakeTaskRepository()),
        );

        final Finder fab = find.byType(FloatingActionButton);
        await tester.tap(fab);
        await tester.pumpAndSettle();
        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('Find and fill text form field', (WidgetTester tester) async {
        final Finder textFormField = find.byType(TextFormField);
        await tester.tap(textFormField);
        await tester.enterText(find.byType(TextFormField), 'test task');
        await tester.pumpAndSettle();
        expect(find.text('test task'), findsOneWidget);
      });

      testWidgets('Find and fill text form field', (WidgetTester tester) async {
        final Finder priorityButton = find.byType(PopupMenuButton);
        await tester.tap(priorityButton);
        await tester.tap(find.text('Низкий'));
        await tester.pumpAndSettle();
        expect(find.text('Низкий'), findsOneWidget);
      });

      testWidgets('Find deadline calendar', (WidgetTester tester) async {
        final Finder deadlineWidget = find.byType(SwitchListTile);
        await tester.tap(deadlineWidget);
        expect(find.byType(TableCalendar), findsOneWidget);
        await tester.tap(find.text('Отмена'));
        await tester.pumpAndSettle();
        expect(find.text('Сделать до'), findsOneWidget);
      });

      testWidgets('Save task', (WidgetTester tester) async {
        final Finder saveButton = find.byType(AppTextButton);
        await tester.tap(saveButton);
        expect(find.byType(FloatingActionButton), findsOneWidget);
      });
    },
  );
}
