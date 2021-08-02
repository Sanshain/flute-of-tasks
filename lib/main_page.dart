import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:some_app/pages/fragments/quick_new.dart';
import 'package:some_app/pages/fragments/task_item.dart';
//import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:some_app/transitions/instant.dart';
import 'package:some_app/widgets/popups.dart';


import 'models/dao/tasks_dao.dart';
import 'models/tasks.dart';
import 'panel.dart';


/// MainPage
class MainPage extends StatefulWidget {
    const MainPage(this.tasks, {Key? key, required this.title}) : super(key: key);

    final String title;
    final TaskDao tasks;

    @override
    State<MainPage> createState() => MainPageState();
}


/// MainPageState
class MainPageState extends State<MainPage> {


  int selectedTab = 0;
  int selectedIndex = -1;
  bool inDetail = false;

  bool quickNew = false;
  int? rootTask;

  String? newTaskNameTitle;
  BuildContext? rootContext;

  List<BuildContext?>? subContextWrapper = <BuildContext?>[null];
  final List<Task> archive = [];
  final List<Task> tasks = [];


  @override
  void initState() {
    super.initState();                                  //      Future.delayed(Duration.zero,() { });

    widget.tasks.all().then((_tasks) {
        stdout.write(_tasks.toString());
    });

    widget.tasks.readWChildren().then((_tasks) {

        stdout.write(_tasks.toString());
        setState((){
            tasks.addAll(_tasks.where((task) => task.isDone == false));
            archive.addAll(_tasks.where((task) => task.isDone));
        });
    });
  }



  Widget listTileGenerate(int index){

      return createListViewPoint(
          context,
          index,
          subContextWrapper: subContextWrapper,
          tasks: tasks,
          confirmDismiss: (DismissDirection direction) async {
              if(direction == DismissDirection.endToStart) {
//                  var poll = await showConfirmationDialog(context, 'Вы уверены, что желаете удалить task-у?');
//                  return poll ?? false;
                  showConfirmationDialog(context, 'Вы уверены, что желаете удалить task-у?').then((poll) async {

                      if (poll ?? false){
                          await widget.tasks.deleteItem(tasks[index]);
                          setState(() => tasks.removeAt(index));

//                          ScaffoldMessenger.of(context).showSnackBar(
//                              const SnackBar(content: Text("item dismissed"))
//                          );
                      }
                  });
              }
              return true;
          },
          onDismissed: (direction) async {

              if(direction == DismissDirection.startToEnd) { // Right Swipe

                  tasks[index].isDone = true;
                  await widget.tasks.updateItem(tasks[index]);

                  setState(() {
                      archive.add(tasks[index]);
                      tasks.removeAt(index);
                  });
              }
              else if(direction == DismissDirection.endToStart) {
                  // move to confirmDismiss
              }
          },
          onTap: () {

              setState(() => inDetail = true );
              return (Task? task) async {
                  if (task is Task){
                      await widget.tasks.updateItem(task);
                  }
                  setState(() => inDetail = false);
              };
          },
          subTaskCreateAction: () {
              setState(() => quickNew = true);
              rootTask = tasks[index].id;
          },
          expandAction: (){

          },
          rootContext: rootContext!
      );
  }





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
                if (index == 1) {
                  return CupertinoDemoTab(
                    title: tabInfo[index].title,
                    icon: tabInfo[index].icon,
                  );
                }
                else if (index == 2){

                    return Column(
                      children: [
                        Expanded(child: ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemCount: archive.length,
                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                            itemBuilder: (BuildContext context, int index) {
                                return createListViewPoint(context, index,
                                    toLeft: const SwipeBackground(Colors.orangeAccent, Icon(Icons.unarchive_outlined)),
                                    toRight: const SwipeBackground(Colors.redAccent, Icon(Icons.delete_forever)),
                                    subContextWrapper: subContextWrapper,
                                    tasks: archive,
                                    onDismissed: (direction) async {
                                        if(direction == DismissDirection.endToStart)
                                        {
                                            archive[index].isDone = false;
                                            await widget.tasks.updateItem(archive[index]);

                                            setState(() {
                                                tasks.add(archive[index]);
                                                archive.removeAt(index);
                                            });
                                        }
                                        else if(direction == DismissDirection.startToEnd){

                                            await widget.tasks.deleteItem(archive[index]);
                                            setState(() => archive.removeAt(index));
                                        }
                                    },
                                    onTap: () {
                                        setState(() => inDetail = true );
                                        return (Task? task) async {
                                            if (task is Task){
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
                else{
                  return Stack(
                    children: [
                      Column(
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
                              separatorBuilder: (BuildContext context, int index) => const Divider(),
                              itemBuilder: (BuildContext context, int index) {
//                                return createListViewPoint(context, index);
                                return createListViewPoint(
                                  context,
                                  index,
                                  subContextWrapper: subContextWrapper,
                                  tasks: tasks,
                                  confirmDismiss: (DismissDirection direction) async {
                                      if(direction == DismissDirection.endToStart) {
//                                          var poll = await showConfirmationDialog(context, 'Вы уверены, что желаете удалить task-у?');
//                                          return poll ?? false;
                                          showConfirmationDialog(context, 'Вы уверены, что желаете удалить task-у?').then((poll) async {

                                              if (poll ?? false){
                                                  await widget.tasks.deleteItem(tasks[index]);
                                                  setState(() => tasks.removeAt(index));

//                                                  ScaffoldMessenger.of(context).showSnackBar(
//                                                      const SnackBar(content: Text("item dismissed"))
//                                                  );
                                              }
                                          });
                                      }
                                      return true;
                                  },
                                  onDismissed: (direction) async {

                                      if(direction == DismissDirection.startToEnd) { // Right Swipe

                                          tasks[index].isDone = true;
                                          await widget.tasks.updateItem(tasks[index]);

                                          setState(() {
                                              archive.add(tasks[index]);
                                              tasks.removeAt(index);
                                          });
                                      }
                                      else if(direction == DismissDirection.endToStart) {
                                        // move to confirmDismiss
                                      }
                                  },
                                  onTap: () {

                                    setState(() => inDetail = true );
                                    return (Task? task) async {
                                        if (task is Task){
                                            await widget.tasks.updateItem(task);
                                        }
                                        setState(() => inDetail = false);
                                    };
                                  },
                                  subTaskCreateAction: () {
                                      setState(() => quickNew = true);
                                      rootTask = tasks[index].id;
                                  },
                                  expandAction: (){

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
              defaultTitle: tabInfo[index].title,
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
                newTaskNameTitle = null;
                setState((){
                    if (text.isNotEmpty) tasks.insert(0, Task.init(text));
                    quickNew = false;
                });
            },
            onChanged: (String text){
                newTaskNameTitle = text;
            },
            onPressed: () async {

                var task = Task.init(newTaskNameTitle!, parent: rootTask);
                await widget.tasks.insertItem(task);
                rootTask = null;

                setState(()  {
//                    if (newTaskName != null && newTaskName!.isNotEmpty) tasks.insert(0, Task(newTaskName!));
                    if (newTaskNameTitle?.isNotEmpty ?? false) {
                        tasks.insert(0, task);
                    }
                    quickNew = false;
                });

//                Navigator.pop(context);
            },
        ),
      );
  }

}
