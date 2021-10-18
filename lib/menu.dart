import 'package:flutter/material.dart';
import 'package:sanshain_tasks/pages/places_page.dart';
import 'package:sanshain_tasks/transitions/instant.dart';

import 'pages/settings_page.dart';


List<PopupMenuItem<Text>> menu (context, widget) {
    return [
        PopupMenuItem(
            child: GestureDetector(
                child: const Expanded(child: Text("Settings")),
                onTap: () => Navigator.push(context, PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(themeNotifier: widget.themeNotifier),
                    transitionsBuilder: instantTransition,
                ))
                // MaterialPageRoute(builder: (context) => SettingsPage(),
            )
        ),
        PopupMenuItem(
            child: GestureDetector(
                child: const Expanded(child: Text("My places")),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PlacesPage())),
            )
        )
    ];
}