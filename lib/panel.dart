import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';



class TabInfo {
    const TabInfo(this.title, this.icon);

    final String title;
    final IconData icon;
}

final tabInfo = [
    const TabInfo(
        'by time',
        CupertinoIcons.home,
    ),
    const TabInfo(
        'by place',
//    CupertinoIcons.conversation_bubble,
//    CupertinoIcons.location_circle,
//      Icons.add_location_alt
        Icons.my_location
    ),
    const TabInfo(
        'Archived',
//    CupertinoIcons.profile_circled,
        CupertinoIcons.archivebox,
    ),
];



class CupertinoDemoTab extends StatelessWidget {
    const CupertinoDemoTab({
        Key? key,
        required this.title,
        required this.icon,
    }) : super(key: key);

    final String title;
    final IconData icon;

    @override
    Widget build(BuildContext context) {
        return CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(),
            backgroundColor: CupertinoColors.systemBackground,
            child: Center(
                child: Icon(
                    icon,
                    semanticLabel: title,
                    size: 100,
                ),
            ),
        );
    }
}