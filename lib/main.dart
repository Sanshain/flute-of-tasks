
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main_page.dart';
import 'models/dao/tasks_dao.dart';
import 'models/database/database.dart';
import 'models/tasks.dart';
//import 'models/migrations/init.dart';

import 'package:get/get.dart';


void main() async {

    WidgetsFlutterBinding.ensureInitialized();

    final database = await $FloorAppDatabase
        .databaseBuilder('app_database_2.db')
//        .addMigrations([migration_1To2])
        .build();

    final TaskDao tasks = Task.tasks = database.taskDao;

    runApp(App(tasks));
//    runApp(const App(tasks));
}

class App extends StatelessWidget {
    const App(this.tasks, {Key? key}) : super(key: key);

    final TaskDao tasks;

    @override
    Widget build(BuildContext context) {
//        return MaterialApp(
        return GetMaterialApp(
            title: 'Some Awesome App',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
//      home: const MainPage(tasks, title: 'The Tasks'),
            home: MainPage(tasks, title: 'The Tasks'),
        );
    }
}


