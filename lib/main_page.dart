import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:some_app/transitions/instant.dart';
import 'package:some_app/views/create_view.dart';
import 'package:some_app/views/sub_views/quick_new.dart';
import 'package:some_app/views/sub_views/task_item.dart';
import 'package:some_app/widgets/popups.dart';

import 'models/tasks.dart';
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

final _tabInfo = [
  const _TabInfo(
    'by time',
    CupertinoIcons.home,
  ),
  const _TabInfo(
    'by place',
    CupertinoIcons.conversation_bubble,
  ),
  const _TabInfo(
    'Archived',
    CupertinoIcons.profile_circled,
  ),
];




class MainPageState extends State<MainPage> {
  int _counter = 0;

  int selectedTab = 0;
  int selectedIndex = -1;
  bool inDetail = false;
  bool quickNew = false;
  String? newTaskName;
  BuildContext? rootContext;

  List<BuildContext?>? subContextWrapper = <BuildContext?>[
    null
  ];

  final List<Task> tasks = [
    Task('my title')
  ];

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {

    rootContext = context;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title} + ${selectedTab.toString()}"),
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
          onTap: (int index) {

            setState(() => selectedTab = index);

          }
        ),
        tabBuilder: (context, index) {
          return WillPopScope(
            onWillPop: () async {
              if (inDetail && selectedTab == 0) {

                setState(() => inDetail = false );
// ???
                if (subContextWrapper!.isNotEmpty && subContextWrapper!.last != null){
                  Navigator.pop(subContextWrapper!.last!);
                }

                return false;
              }

              return true;
            },
            child: CupertinoTabView(
              restorationScopeId: 'cupertino_tab_view_$index',
              builder: (context) {
                if (selectedTab > 0) {
                  return CupertinoDemoTab(
                    title: _tabInfo[index].title,
                    icon: _tabInfo[index].icon,
                  );
                }
                else{
                  return Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Text(
                                '$_counter ( selected $selectedIndex)',
                                style: Theme.of(context).textTheme.headline6,
                              )
                          ),
                          Expanded(child: ListView.separated(
                              padding: const EdgeInsets.all(8),
                              itemCount: tasks.length,
                              separatorBuilder: (BuildContext context, int index) => const Divider(),
                              itemBuilder: (BuildContext context, int index) {
//                                return createListViewPoint(context, index);
                                return createListViewPoint(context, index,
                                  subContextWrapper: subContextWrapper,
                                  tasks: tasks,
                                  onTap: () {
                                    setState(() => inDetail = true );
                                    return () {
                                        setState(() => inDetail = false);
                                    };
                                  },
                                  rootContext: rootContext!
                                );
                              }
                          )),
                        ],
                      ),
                      _createQuickTask(),
                    ]
                  );
                }
              },
              defaultTitle: _tabInfo[index].title,
            ),
          );
        },
      ) ,
        floatingActionButton: Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: selectedTab == 0 && inDetail == false && quickNew == false,
          child: Container(
            padding: const EdgeInsets.only(bottom: 50.0, right: 15.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {

                  setState((){
                    quickNew = true;
                  });

//                  Navigator.push(
//                      context,
//                      PageRouteBuilder(
//                        pageBuilder: (context, animation, secondaryAnimation) => TaskEdit(subContextWrapper, title: ''),
//                        transitionsBuilder: instantTransition,
//                      )
////                      MaterialPageRoute(builder: (context) => TaskEdit(subContextWrapper, title: ''))
//                  );

//                  popup(context, 'some content', title: 'title');
//                  input(context, 'some content', title: 'title');
                },
                child: const Icon(Icons.add),
//              icon: const Icon(Icons.phone_android),
//              label: const Text("Authenticate using Phone"),
              ),
            ),
          ),
        ),
//        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat
    );
  }


  Visibility _createQuickTask() {
    return Visibility(
        visible: quickNew == true,
        child: createQuickTask(
            onSubmitted: (String text){
                newTaskName = null;
                setState((){
                    if (text.isNotEmpty) tasks.insert(0, Task(text));
                    quickNew = false;
                });
            },
            onChanged: (String text){
                newTaskName = text;
            },
            onPressed: () {
                setState((){
//                    if (newTaskName != null && newTaskName!.isNotEmpty) tasks.insert(0, Task(newTaskName!));
                    if (newTaskName?.isNotEmpty ?? false) tasks.insert(0, Task(newTaskName!));
                    quickNew = false;
                });
//                Navigator.pop(context);
            },
        ),
      );
  }

}
