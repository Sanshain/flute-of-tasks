import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sanshain_tasks/utils/localizations.dart';

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
    final Places places = Place.objects = database.placesHandler;

    runApp(App(tasks, places));
//    runApp(const App(tasks));
}

class App extends StatelessWidget {
    const App(this.tasks, this.places, {Key? key}) : super(key: key);

    final TaskDao tasks;
    final Places places;

    @override
    Widget build(BuildContext context) {

        final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

//        return MaterialApp(
        return ValueListenableBuilder(
            valueListenable: themeNotifier,
            builder: (BuildContext context, ThemeMode value, Widget? child) {
                return GetMaterialApp(
                    title: 'Some Awesome App',
                    themeMode: value,
                    darkTheme: ThemeData.dark(),
//                  darkTheme: ThemeData(
//                      primarySwatch: Colors.black,
//                  ),
                    theme: ThemeData(
                        primarySwatch: Colors.blue,
                    ),
                    supportedLocales: const [
                        Locale('en', 'US'),
                        Locale('es', ''),
                        Locale('ru', ''),
                    ],
                    localizationsDelegates: const [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                    ],
//                  home: const MainPage(tasks, title: 'The Tasks'),
                    home: MainPage(tasks, places, title: 'The Tasks', themeNotifier: themeNotifier,),
                );
            },
        );
    }
}


