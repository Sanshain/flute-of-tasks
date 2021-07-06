import 'package:flutter/cupertino.dart';

import 'package:flutter_localizations/flutter_localizations.dart';


//class _TabInfo {
//    const _TabInfo(this.title, this.icon);
//
//    final String title;
//    final IconData icon;
//}
//
//class CupertinoTabBarDemo extends StatelessWidget {
//    const CupertinoTabBarDemo({Key key}) : super(key: key);
//
//    @override
//    Widget build(BuildContext context) {
//
//        return DefaultTextStyle(
//
//            style: CupertinoTheme.of(context).textTheme.textStyle,
//            child: CupertinoTabScaffold(
//                restorationId: 'cupertino_tab_scaffold',
//                tabBar: CupertinoTabBar(
//                    items: [
//                        for (final tabInfo in _tabInfo)
//                            BottomNavigationBarItem(
//                                label: tabInfo.title,
//                                icon: Icon(tabInfo.icon),
//                            ),
//                    ],
//                ),
//                tabBuilder: (context, index) {
//                    return CupertinoTabView(
//                        restorationScopeId: 'cupertino_tab_view_$index',
//                        builder: (context) => _CupertinoDemoTab(
//                            title: _tabInfo[index].title,
//                            icon: _tabInfo[index].icon,
//                        ),
//                        defaultTitle: _tabInfo[index].title,
//                    );
//                },
//            ),
//        );
//    }
//}



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