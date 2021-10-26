import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sanshain_tasks/controller.dart';
import 'package:sanshain_tasks/utils/localizations.dart';
import 'package:sanshain_tasks/utils/notifications.dart';

import 'main_page.dart';
import 'models/dao/tasks_dao.dart';
import 'models/database/database.dart';
import 'models/tasks.dart';
//import 'models/migrations/init.dart';

import 'package:get/get.dart';


void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = Controller.storage = await $FloorAppDatabase
        .databaseBuilder('app_database_2.db')
        // .addMigrations([migration_1To2])
        .build();

    final TaskDao tasks = Task.tasks = database.taskDao;
    final Places places = Place.objects = database.placesHandler;

    App.notification = await notificationsInitialize(App.onLocalNotification, App.selectNotification);

    runApp(App(tasks, places));
//    runApp(const App(tasks));
}


class App extends StatelessWidget {

    const App(this.tasks, this.places, {Key? key}) : super(key: key);

    final TaskDao tasks;
    final Places places;


    static BuildContext? context;
    static FlutterLocalNotificationsPlugin? notification;


//    Widget mainPage({themeNotifier}) => MainPage(tasks, places, title: 'The Tasks', themeNotifier: themeNotifier);
    static Widget mainPage({themeNotifier}) => MainPage(Task.tasks!, Place.objects!, title: 'The Tasks', themeNotifier: themeNotifier);


    ///
    /// triggered on click to notification
    ///
    static void selectNotification(String? payload) async
    {
        if (payload != null) { debugPrint('notification payload: $payload'); }
        await Navigator.push(
            App.context!, MaterialPageRoute<void>(builder: (context) => mainPage()),
        );
    }

    ///
    /// display a dialog with the notification details, tap ok to go to another page (onDidReceiveLocalNotification)
    ///
    static void onLocalNotification(int id, String? title, String? body, String? payload) async {
        if (App.context == null) { return; }
        showDialog(
            context: App.context!,
            builder: (BuildContext context) =>
                CupertinoAlertDialog(
                    title: Text(title ?? ''),
                    content: Text(body ?? ''),
                    actions: [
                        CupertinoDialogAction(
                            isDefaultAction: true,
                            child: const Text('Ok'),
                            onPressed: () async {
                                Navigator.of(context, rootNavigator: true).pop();
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => mainPage(),
                                    ),
                                );
                            },
                        )
                    ],
                ),
        );
    }



    @override
    Widget build(BuildContext context) {

        App.context = context;

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



