import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'panel.dart';
import 'task_view.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Some Awesome App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(title: 'The Tasks'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => MainPageState();
}

class _TabInfo {
  const _TabInfo(this.title, this.icon);

  final String title;
  final IconData icon;
}


class MainPageState extends State<MainPage> {
  int _counter = 0;

  int selectedTab = 0;
  int selectedIndex = -1;
  final List<String> users = [
    "Tom", "Alice", "Sam", "Bob", "Kate",
    "Tom", "Alice", "Sam", "Bob", "Kate",
    "Tom", "Alice", "Sam", "Bob", "Kate"
  ];

  void _incrementCounter() {
    setState(() => _counter++);
  }

  Widget _createListView(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: index == selectedIndex ? Colors.black12: Colors.white60,
        child: Text(users[index], style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final _tabInfo = [
      const _TabInfo(
        'Active',
        CupertinoIcons.home,
      ),
      const _TabInfo(
        'Perfomed',
        CupertinoIcons.conversation_bubble,
      ),
      const _TabInfo(
        'Archived',
        CupertinoIcons.profile_circled,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + selectedTab.toString()),
      ),
      body: CupertinoTabScaffold(
        restorationId: 'cupertino_tab_scaffold',
        tabBar: CupertinoTabBar(
          items: [
            for (final tabInfo in _tabInfo)
              BottomNavigationBarItem(
                label: tabInfo.title,
                icon: Icon(tabInfo.icon),
//                onTap: () => {}
              ),
          ],
        ),
        tabBuilder: (context, index) {
          return CupertinoTabView(
            restorationScopeId: 'cupertino_tab_view_$index',
            builder: (context) {
              selectedTab = index;
              return CupertinoDemoTab(
                title: _tabInfo[index].title,
                icon: _tabInfo[index].icon,
              );
            },
            defaultTitle: _tabInfo[index].title,
          );
        },
      ) ,
//      Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: [
//          Center(
//              child: Text(
//                '$_counter (selected $selectedIndex)',
//                style: Theme.of(context).textTheme.headline6,
//              )
//          ),
//          Expanded(child: ListView.separated(
//              padding: const EdgeInsets.all(8),
//              itemCount: users.length,
//              separatorBuilder: (BuildContext context, int index) => const Divider(),
//              itemBuilder: (BuildContext context, int index) {
//                return ListTile(
//                    onTap: () {
//                      Navigator.push(
//                          context,
//                          _createRoute(users[index])
////                          MaterialPageRoute(builder: (context) => TaskPage(title: users[index]))
//                      );
////                      setState(() => selectedIndex = index);
//                    },
//                    title: Text(users[index], style: const TextStyle(fontSize: 22)),
//                    leading: const Icon(Icons.face),
//                    trailing: const Icon(Icons.phone),
//                    tileColor: index == selectedIndex ? Colors.black12: Colors.white60,
//                    subtitle: Text("Works in ${users[index]}")
//                );
//              }
//          ))
//        ],
//      ),
        floatingActionButton: selectedTab == 1 ? Container(
          padding: const EdgeInsets.only(bottom: 50.0, right: 15.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
//              icon: const Icon(Icons.phone_android),
//              label: const Text("Authenticate using Phone"),
            ),
          ),
        ) : null,
//        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat
    );
  }


  Route _createRoute(String pageTitle) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => TaskPage(title: pageTitle),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return child;
      },
    );
  }

}
