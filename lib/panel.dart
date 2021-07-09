import 'package:flutter/cupertino.dart';

import 'package:flutter_localizations/flutter_localizations.dart';



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