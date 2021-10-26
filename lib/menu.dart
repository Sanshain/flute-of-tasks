import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sanshain_tasks/pages/places_page.dart';
import 'package:sanshain_tasks/transitions/instant.dart';
import 'package:sanshain_tasks/utils/localizations.dart';
import 'package:sanshain_tasks/utils/notifications.dart';
import 'package:sanshain_tasks/widgets/popups.dart';

import 'main.dart';
import 'pages/settings_page.dart';


List<PopupMenuItem<Text>> menu(context, widget) {
    return [
        PopupMenuItem(
            child: GestureDetector(
                child: Row(children: [Expanded(child: Text(AppLocalizations.of(context)!.translate("settings")))]),
                onTap: () async {
                    await Navigator.push(context, PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(themeNotifier: widget.themeNotifier),
                        transitionsBuilder: instantTransition,
                    ));
                    Navigator.pop(context);
                }
                // MaterialPageRoute(builder: (context) => SettingsPage(),
            )
        ),
        PopupMenuItem(
            child: GestureDetector(
                child: Row(children: [Expanded(child: Text(AppLocalizations.of(context)!.translate("Places")))]),
                onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => const PlacesPage()));
                    Navigator.pop(context);
                },
            )
        ),
        PopupMenuItem(
            child: GestureDetector(
                child: Row(children: [Expanded(child: Text(AppLocalizations.of(context)!.translate('exit')))],),
                onTap: () => Platform.operatingSystem == 'android' ? SystemNavigator.pop() : exit(0),
            )
        ),
//        PopupMenuItem(
//            child: GestureDetector(
//                child: Row(children: const [Expanded(child: Text("Notification test"))]),
//                onTap: () async {
//                    await scheduleNotify(context, message: 'message', title: 'title', time: DateTime.now().add(const Duration(seconds: 5)));
//                    Navigator.pop(context);
//                },
//            )
//        ),
    ];
}

