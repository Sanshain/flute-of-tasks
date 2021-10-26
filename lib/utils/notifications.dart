import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

typedef OnReceive = void Function(int, String?, String?, String?);

///
/// инициализация уведомлений
///
Future<FlutterLocalNotificationsPlugin> notificationsInitialize(DidReceiveLocalNotificationCallback onReceive, SelectNotificationCallback selectNotification) async
{
    tz.initializeTimeZones();

    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project:

    const initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onReceive);
    const initializationSettingsMacOS = MacOSInitializationSettings();

    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);

    return flutterLocalNotificationsPlugin;
}

///
/// show notification
///
Future<void> scheduleNotify(context, {String title = '', required String message, required DateTime time, String? taskId}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        taskId ?? 'some channel id',
        'tasks channel',
        channelDescription: 'upcoming tasks',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker'
    );

    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//    await App.notification!.show(0,
//        title,
//        message,
//        platformChannelSpecifics,
//        payload: 'item x'
//    );


    await App.notification!.zonedSchedule(0,
        title,
        message,
//        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        tz.TZDateTime.from(time, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
}