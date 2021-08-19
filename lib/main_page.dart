import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:some_app/controller.dart';

import 'package:some_app/pages/fragments/quick_new.dart';
import 'package:some_app/pages/fragments/task_item.dart';
import 'package:some_app/pages/placed_tasks.dart';
import 'package:some_app/pages/places_page.dart';
import 'package:some_app/pages/settings_page.dart';

//import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:some_app/transitions/instant.dart';
import 'package:some_app/widgets/popups.dart';


import 'models/dao/tasks_dao.dart';
import 'models/tasks.dart';
import 'panel.dart';

import 'package:collection/collection.dart';


/// MainPage
class MainPage extends StatefulWidget {
    const MainPage(this.tasks, this.places, {Key? key, required this.title}) : super(key: key);

    final String title;

    final TaskDao tasks;
    final Places places;

    @override
    State<MainPage> createState() => MainPageState();

}


/// MainPageState
class MainPageState extends State<MainPage> implements IExpandedTaskList {

    List<String> tabTitle = [
        'Задачи',
        'Места',
        'Архив',
    ];

    int selectedTab = 0;
    int selectedIndex = -1;
    bool inDetail = false;

    bool quickNew = false;
    int? rootTaskId;
    int? rootTaskIndex;

    String? newTaskNameTitle;
    BuildContext? rootContext;

    List<BuildContext?>? subContextWrapper = <BuildContext?>[null];
    final List<Task> archive = [];
    final List<Task> tasks = [];

    void Function(Task)? useSubTasksUpdate;
    final Controller controller = Get.put(Controller());


    @override
    void initState() {
        super.initState(); //      Future.delayed(Duration.zero,() { });

        widget.places.all().then((_places) {
           controller.initPlaces(_places);
        });

        widget.tasks.all().then((_tasks) {
            controller.setTasks(_tasks);

            stdout.write(_tasks.toString());
            archive.addAll(
                _tasks.where((task) {
                    task.parentName = _tasks.where((t) => task.parent == t.id).firstOrNull?.title;
                    return task.isDone && _tasks.where((t) => task.id == t.parent).isEmpty;
                })
            );
        });

        widget.tasks.readWChildren().then((_tasks) {

            stdout.write(_tasks.toString());
            setState(() {
                tasks.addAll(_tasks.where((task) => task.isDone == false));
//                archive.addAll(
//                    _tasks.where((task) {
//                        return task.isDone && _tasks.where((t) => t.parent == task.id).isEmpty;
//                    })
//                );
            });
        });
    }

    @override
    Widget listTileGenerate(int index, {
        BuildContext? parentContext,
        List<BuildContext?>? childContextWrapper,
        List<Task>? parentTasks,
        Task? parentTask,
        int deep = 0
    }) {

        parentContext = parentContext ?? rootContext;
        childContextWrapper = childContextWrapper ?? subContextWrapper;
        var tasks = parentTasks ?? this.tasks;

//        return createListViewPoint(
        return ListViewItem(
            context,
            index,
            subContextWrapper: childContextWrapper,
            parentTask: parentTask,
            tasks: tasks,
            parent: this,
            deep: deep,
            toRight: const SwipeBackground(
                Colors.orangeAccent, Icon(Icons.unarchive_outlined)),
            toLeft: const SwipeBackground(
                Colors.redAccent, Icon(Icons.delete_forever)),
            confirmDismiss: (DismissDirection direction) async {
                if (direction == DismissDirection.endToStart) {
//                  var poll = await showConfirmationDialog(context, 'Вы уверены, что желаете удалить task-у?');
//                  return poll ?? false;
                    showConfirmationDialog(context, 'Вы уверены, что желаете удалить task-у?').then((poll) async {
                        if (poll ?? false) {
                            await widget.tasks.deleteItem(tasks[index]);
                            setState(() => tasks.removeAt(index));

//                          ScaffoldMessenger.of(context).showSnackBar(
//                              const SnackBar(content widget: Text("item dismissed"))
//                          );
                        }
                    });
                }
                return true;
            },
            onDismissed: (direction) async {
                if (direction == DismissDirection.startToEnd) { // Right Swipe

                    tasks[index].isDone = true;
                    tasks[index].deadline = DateTime.now();
                    await widget.tasks.updateItem(tasks[index]);

                    setState(() {
                        tasks[index].parentName = controller.tasks.where((t) => tasks[index].parent == t.id).firstOrNull?.title;
                        archive.add(tasks[index]);
                        tasks.removeAt(index);
                    });
                }
                else if (direction == DismissDirection.endToStart) {
                    // move to confirmDismiss
                }
            },
            onTap: () {
                setState(() => inDetail = true);
                return (Task? task) async {
                    if (task is Task) {
                        await widget.tasks.updateItem(task);
                    }
                    setState(() => inDetail = false);
                };
            },
//            subTaskCreateAction: (void Function(Task)? callbackUpState) {
            subTaskCreateAction: ({void Function(Task)? onApply}) {
                setState(() => quickNew = true);
                useSubTasksUpdate = onApply;
                rootTaskId = tasks[index].id;
                rootTaskIndex = index;
            },
            expandAction: () {

            },
            rootContext: parentContext!
        );
    }

    @override
    Widget build(BuildContext context) {
        rootContext = context;

        return Scaffold(
            appBar: AppBar(
//                title: Text("${widget.title} + ${selectedTab.toString()}"),
                title: Text(tabTitle[selectedTab]),
                actions: [
                    const Icon(Icons.search),
                    PopupMenuButton<Text>(
                        itemBuilder: (context){
                            return [
                                PopupMenuItem(
                                    child: GestureDetector(
                                        onTap: (){
                                            popup(context, 'todo');
                                            Navigator.push(context,
                                              PageRouteBuilder(
                                                pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(),
                                                transitionsBuilder: instantTransition,
                                              )
                                            //                                              MaterialPageRoute(builder: (context) => SettingsPage()
                                            );
                                        },
                                        child: const Text("Settings")
                                    )
                                ),
                                PopupMenuItem(
                                    child: GestureDetector(
                                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PlacesPage())),
                                        child: const Text("My places")
                                    )
                                )
                            ];
                        },
                    )
                ],
            ),
            body: CupertinoTabScaffold(
                restorationId: 'cupertino_tab_scaffold',
                tabBar: CupertinoTabBar(
                    items: [
                        for (final tabInfo in tabInfo)
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
                                setState(() => inDetail = false);
// ???
                                if (subContextWrapper!.isNotEmpty && subContextWrapper!.last != null) {
                                    Navigator.pop(subContextWrapper!.last!);
                                }
                                return false;
                            }
                            return true;
                        },
                        child: CupertinoTabView(
                            restorationScopeId: 'cupertino_tab_view_$index',
                            builder: (context) {
                                if (index == 1) {
                                    return const PlacedTasksPage();
                                    return CupertinoDemoTab(
                                        title: tabInfo[index].title,
                                        icon: tabInfo[index].icon,
                                    );
                                }
                                else if (index == 2) {
                                    return Column(
                                        children: [
                                            Expanded(child: ListView.separated(
                                                padding: const EdgeInsets.all(8),
                                                itemCount: archive.length,
                                                separatorBuilder: (BuildContext context, int index) => const Divider(),
                                                itemBuilder: (BuildContext context, int index) {
                                                    return createListViewPoint(context, index,
                                                        toLeft: const SwipeBackground(
                                                            Colors.orangeAccent, Icon(Icons.unarchive_outlined)),
                                                        toRight: const SwipeBackground(
                                                            Colors.redAccent, Icon(Icons.delete_forever)),
                                                        subContextWrapper: subContextWrapper,
                                                        tasks: archive,
                                                        onDismissed: (direction) async {
                                                            if (direction == DismissDirection.endToStart) {
                                                                archive[index].isDone = false;
                                                                await widget.tasks.updateItem(archive[index]);

                                                                setState(() {
                                                                    tasks.add(archive[index]);
                                                                    archive.removeAt(index);
                                                                });
                                                            }
                                                            else if (direction == DismissDirection.startToEnd) {
                                                                await widget.tasks.deleteItem(archive[index]);
                                                                setState(() => archive.removeAt(index));
                                                            }
                                                        },
                                                        onTap: () {
                                                            setState(() => inDetail = true);
                                                            return (Task? task) async {
                                                                if (task is Task) {
                                                                    await widget.tasks.updateItem(task);
                                                                }
                                                                setState(() => inDetail = false);
                                                            };
                                                        },
                                                        rootContext: rootContext!
                                                    );
                                                }
                                            )),
                                        ],
                                    );
                                }
                                else {
                                    return Stack(
                                        children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 32),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
//                          Center(
//                              child: Text(
//                                  _tabInfo[index].title,  // '( selected $selectedIndex)',
//                                style: Theme.of(context).textTheme.headline6,
//                              )
//                          ),
                                                      Expanded(child: ListView.separated(
                                                          padding: const EdgeInsets.all(8),
                                                          itemCount: tasks.length,
                                                          separatorBuilder: (BuildContext context,
                                                              int index) => const Divider(),
                                                          itemBuilder: (BuildContext context, int index) {
//                                return createListViewPoint(context, index);
                                                              return listTileGenerate(index);
                                                          }
                                                      )),
                                                  ],
                                              ),
                                            ),
//                                            _createQuickTask(),
                                        ]
                                    );
                                }
                            },
                            defaultTitle: tabInfo[index].title,
                        ),
                    );
                },
            ),
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
                            onPressed: () async {

                                var newTaskNameTitle = await inputDialog(context, title: 'Enter new task title');
                                if (newTaskNameTitle?.isNotEmpty ?? false){

                                    var task = Task.init(newTaskNameTitle!, parent: rootTaskId);
                                    await widget.tasks.insertItem(task);

                                    setState(() {

                                            if (rootTaskId == null){tasks.insert(0, task);}
                                            else {
                                                tasks[rootTaskIndex!].subTasksAmount = tasks[rootTaskIndex!].subTasksAmount! + 1;
                                                useSubTasksUpdate?.call(task);
                                            }
                                        }
                                    );
                                }

//                                setState(() {
//                                    quickNew = true;
//                                });

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
                onSubmitted: (String text) {
                    newTaskNameTitle = null;
                    setState(() {
                        if (text.isNotEmpty) tasks.insert(0, Task.init(text));
                        quickNew = false;
                    });
                },
                onChanged: (String text) {
                    newTaskNameTitle = text;
                },
                onPressed: () async {
                    var task = Task.init(newTaskNameTitle!, parent: rootTaskId);
                    await widget.tasks.insertItem(task);

                    setState(() {
//                    if (newTaskName != null && newTaskName!.isNotEmpty) tasks.insert(0, Task(newTaskName!));
                        if (newTaskNameTitle?.isNotEmpty ?? false) {
                            if (rootTaskId == null){
                                tasks.insert(0, task);
                            }
                            else {
//                                tasks[rootTask!].subTasksAmount = tasks[rootTask!].subTasksAmount! + 1;
                                tasks[rootTaskIndex!].subTasksAmount = tasks[rootTaskIndex!].subTasksAmount! + 1;
                                useSubTasksUpdate?.call(task);
                            }
                        }
                        quickNew = false;
                    });

                    rootTaskId = null;
                    useSubTasksUpdate = null;

//                Navigator.pop(context);
                },
            ),
        );
    }

}
