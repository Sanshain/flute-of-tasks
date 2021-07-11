// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:some_app/main_page.dart';
import 'package:some_app/models/dao/tasks_dao.dart';
import 'package:some_app/models/database/database.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {

//    WidgetsFlutterBinding.ensureInitialized();
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    final TaskDao tasks = database.taskDao;

    // Build our app and trigger a frame.
    await tester.pumpWidget(App(tasks));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
