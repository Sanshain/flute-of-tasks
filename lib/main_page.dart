import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sanshain_tasks/controller.dart';
import 'package:sanshain_tasks/pages/mainpage_reef.dart';
import 'package:sanshain_tasks/utils/localizations.dart';

import 'package:sanshain_tasks/utils/speech.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:sanshain_tasks/pages/fragments/quick_new.dart';
import 'package:sanshain_tasks/pages/fragments/task_item.dart';
import 'package:sanshain_tasks/pages/input_page.dart';
import 'package:sanshain_tasks/pages/placed_tasks.dart';
import 'package:sanshain_tasks/pages/places_page.dart';
import 'package:sanshain_tasks/pages/settings_page.dart';

//import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:sanshain_tasks/transitions/instant.dart';
import 'package:sanshain_tasks/widgets/popups.dart';

import 'menu.dart';
import 'models/dao/tasks_dao.dart';
import 'models/tasks.dart';
import 'panel.dart';

import 'package:collection/collection.dart';


const List<String> tabTitle = [
    'Задачи',
    'Места',
    'Архив',
];


class MainPage extends StatefulWidget {

    const MainPage(this.tasks, this.places, {Key? key, required this.title, this.themeNotifier}) : super(key: key);

    final ValueNotifier<ThemeMode>? themeNotifier;

    final String title;
    final TaskDao tasks;
    final Places places;

    @override State<MainPage> createState() => MainPageState();
}


///
/// MainPageState
///
class MainPageState extends State<MainPage> with TasksListView {

    static final GlobalKey<FormFieldState<String>> _searchViewKey = GlobalKey<FormFieldState<String>>();

    @override Widget build(BuildContext context)
    {
        rootContext = context;

        return Scaffold(
            appBar: AppBar(

                title: Text(tabTitle[selectedTab]),
                actions: [
                    GestureDetector(
                        onTap: () async {

                            var order = await choiceDialog(context, orders, title: AppLocalizations.of(context)!.translate('sort by'));
                            var _order = orders.indexOf(order ?? orders.first).toString();
                            if (controller.settings['order'] != _order)
                            {
                                var defaultTime = DateTime.now();
                                controller.settings['order'] = _order;

                                tasks = tasks
                                    ..sort((p, n) {
                                        if (_order == '0') {
                                            return n.created.compareTo(p.created);
                                        } else if (_order == '1') {
                                            return n.getDuration()?.compareTo(p.getDuration() ?? 0) ?? 0;
                                        } else if (_order == '2') {
                                            return n.gravity.compareTo(p.gravity);
                                        } else {
                                            return n.deadline?.compareTo(p.deadline ?? defaultTime) ?? 0;
                                        }
                                    });
                            }
                        },
                        child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.reorder_sharp))
                    ),
                    PopupMenuButton<Text>(itemBuilder: (context) => menu(context, widget))
                ],
            ),
            body: CupertinoTabScaffold(

                restorationId: 'cupertino_tab_scaffold',
                tabBar: CupertinoTabBar(

                    items: [
                        for (final tabInfo in tabInfo) BottomNavigationBarItem(
                            label: tabInfo.title,
                            icon: Icon(tabInfo.icon),
                        )
                    ],
                    onTap: (int index) => setState(() => selectedTab = index),
                ),
                tabBuilder: (context, index)
                {
                    return WillPopScope(

                        onWillPop: onPop,
                        child: CupertinoTabView(

                            restorationScopeId: 'cupertino_tab_view_$index',
                            builder: (context) {
                                if (index == 0) {
                                    return tasksListView(widget: widget, updateState: setState);
                                } else if (index == 1) {
                                    return const PlacedTasksPage();
                                } else {
                                    return buildArchiveTab(widget, subContextWrapper, rootContext, inDetail, setState);
                                }
                            },
                            defaultTitle: tabInfo[index].title,
                        ),
                    );
                },
            ),
            floatingActionButton: buildFloatingView(context, selectedTab: selectedTab, inDetail: inDetail, quickNew: quickNew),
//        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat
        );
    }


    Future<bool> onPop() async
    {
        if (inDetail && selectedTab == 0) {
            setState(() => inDetail = false);
            if (subContextWrapper!.isNotEmpty && subContextWrapper!.last != null) {
                Navigator.pop(subContextWrapper!.last!);
            } else {
                return false;
            }
        }
        return true;
    }


    @override Future<void> createTask(String newTaskNameTitle) async
    {
        var task = Task.init(newTaskNameTitle, parent: rootTaskId);
        await widget.tasks.insertItem(task);

        setState(() {
            if (rootTaskId == null) {
                tasks.insert(0, task);
            }
            else {
                tasks[rootTaskIndex!].subTasksAmount = tasks[rootTaskIndex!].subTasksAmount! + 1;
                useSubTasksUpdate?.call(task);
            }
        });
    }


    @Deprecated("change to inputPage") Visibility _createQuickTask() {
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
                            if (rootTaskId == null) {
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



