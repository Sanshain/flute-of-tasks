import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sanshain_tasks/models/tasks.dart';
import 'package:sanshain_tasks/pages/task_edit_page.dart';
import 'package:sanshain_tasks/transitions/instant.dart';

import '../../controller.dart';
import '../../main_page.dart';


//typedef ChangeState = Function Function();


abstract class IExpandedTaskList {
    Widget listTileGenerate(BuildContext context, int index, {
        required MainPage widget,
        required void Function(VoidCallback cb) stateUpdate,
        BuildContext? parentContext,
        List<BuildContext?>? childContextWrapper,
        List<Task>? parentTasks,
        Task? parentTask,
        int deep = 0
    });
}


class SwipeBackground {

    const SwipeBackground(this.color, this.icon);

    final Color color;
    final Icon icon;
}


class ListViewItem extends StatefulWidget {

    final MainPage page;
    final int deep;
    final int index;
    final List<BuildContext?>? subContextWrapper;
    final SwipeBackground? toLeft;
    final SwipeBackground? toRight;
    final List<Task> tasks;
    final Function(DismissDirection) onDismissed;
    final Future<bool> Function(DismissDirection)? confirmDismiss;
    final Function(Task?) Function() onTap;
    final void Function({void Function(Task)? onApply})? subTaskCreateAction;
    final Function? expandAction;
    final IExpandedTaskList? parent;
    final BuildContext rootContext;
    final Task? parentTask;

    const ListViewItem(BuildContext context, this.index, {
        key,
        required this.page,
        required this.subContextWrapper,
        required this.toLeft,
        required this.toRight,
        required this.tasks,
        required this.onDismissed,
        required this.confirmDismiss,
        required this.onTap,
        required this.subTaskCreateAction,
        required this.expandAction,
        required this.parent,
        required this.rootContext,
        this.parentTask,
        this.deep = 0}) : super(key: key);

    @override
    ListViewItemState createState() => ListViewItemState();
}


class ListViewItemState extends State<ListViewItem> {

    int? rootIndex;
    late Task currentTask;
    List<Task> expandedCache = [];
    int deep = 0;

    late Controller controller;

    @override
    void initState() {
        super.initState(); //      Future.delayed(Duration.zero,() { });
//        controller = Get.find();
    }

    Widget _createListViewPoint(BuildContext context, ListViewItemState self) {
        var widget = self.widget;

        const roundCorners = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)));

        Task? parentTask = widget.parentTask;
        int index = rootIndex = widget.index;
        List<BuildContext?>? subContextWrapper = widget.subContextWrapper;
        SwipeBackground? toLeft = widget.toLeft;
        SwipeBackground? toRight = widget.toRight;
        List<Task> tasks = widget.tasks;
        Function(DismissDirection) onDismissed = widget.onDismissed;
        Future<bool> Function(DismissDirection)? confirmDismiss = widget.confirmDismiss;
        Function(Task?) Function() onTap = widget.onTap;
        Function({Function(Task)? onApply})? subTaskCreateAction = widget.subTaskCreateAction;
        Function? expandAction = widget.expandAction;
        IExpandedTaskList? parent = widget.parent;
        BuildContext rootContext = widget.rootContext;
        deep = widget.deep;

        const btnColors = Color(0xffEEEEEE); // Colors.black26;

//        var order = controller.settings['order'];

        currentTask = tasks[index];

//        return Text(index.toString());

        String taskHint()
        {
//            '${currentTask.title} (${currentTask.activeSubTasksAmount}/${currentTask.subTasksAmount ?? 0}/${currentTask.id})',

            var result = '';

            if (currentTask.deadline != null && currentTask.duration != null) {
                var rest = currentTask.deadline!.difference(DateTime.now());
                var units = currentTask.units;

                result = '(осталось ${currentTask.getDuration()} $units из ${units == 'days' ? rest.inDays : rest.inHours})';
            } else if (currentTask.deadline != null) {
                var rest = currentTask.deadline!.difference(DateTime.now());
                var units = currentTask.units;

                result = '(осталось ${units == 'days' ? rest.inDays : rest.inHours} $units)';
            } else if (currentTask.subTasksAmount != null && currentTask.subTasksAmount != 0) {

                result = '(Выполнено ${currentTask.subTasksAmount ?? 0 - currentTask.activeSubTasksAmount} из ${currentTask.subTasksAmount ?? 0})';
            }

            return result;
        }


        return Dismissible(
//      key: Key(index.toString()),
            key: UniqueKey(),
            onDismissed: (direction) {
                if (parentTask != null) {
                    setState(() {
                        parentTask.doneSubTasksAmount =
                            (parentTask.doneSubTasksAmount ?? 0) + (direction == DismissDirection.startToEnd ? 1 : -1);
                    });
                }
                onDismissed(direction);
            },
            confirmDismiss: confirmDismiss,
            secondaryBackground: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                color: toLeft?.color ?? Colors.red,
                alignment: Alignment.centerRight,
                child: toLeft?.icon ?? const Icon(Icons.cancel),
            ),
            background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                color: toRight?.color ?? Colors.green,
                alignment: Alignment.centerLeft,
                child: toRight?.icon ?? const Icon(Icons.check),
            ),
            child: GestureDetector(
                onTap: () {},
//                child: const Text('123'),

                child: Container(
//                    height: 60.0,
                    margin: const EdgeInsets.symmetric(vertical: 1),
                    padding: const EdgeInsets.symmetric(vertical: 1),
//            color: index == selectedIndex ? Colors.white60: Colors.white60,
                    color: Colors.white60,
//                    child: const Text('1235'),

                    child: ExpansionTile(
//                        trailing: const SizedBox.shrink(),
//                        tilePadding: EdgeInsets.all(0),
//                        childrenPadding: const EdgeInsets.all(0),
//                        collapsedBackgroundColor: Colors.grey,
                        backgroundColor: Colors.black12,
                        collapsedIconColor: (currentTask.subTasksAmount ?? 0) > 0 ? Colors.black54 : Colors.transparent,
                        trailing: null,
//                        trailing: Visibility(
//                            visible: (currentTask.subTasksAmount ?? 0) > 0 ? true : false,
//                            child: const Icon(Icons.expand_less)
//                        ),
//                        collapsedIconColor: expandedCache[rootIndex!].subTasksAmount == 0 ? Colors.black12 : Colors.black54,
                        key: PageStorageKey<String>(rootIndex!.toString()),
//                        key: Key(index.toString()),
                        onExpansionChanged: (bool expanded) async {
                            var startAmount = tasks[index].subTasksAmount;

                            if (expanded && startAmount != expandedCache.length) {
//                                expandedCache = (await tasks[index].children) ?? [];
                                var _index = index;
                                var subTasks = (await tasks[_index].children)?.where((element) => !element.isDone) ?? [];
                                setState(() {
//                                    expandedCache = expandedCache;
//                                    expandedCache = subTasks;
                                    expandedCache = [];
                                    expandedCache.insertAll(expandedCache.length, subTasks);
                                });
                            }
                        },
//                        title: const Text('234'),
                        title: Column(
                            children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Container(
//                                        width: MediaQuery.of(context).size.width - ((currentTask.subTasksAmount ?? 0) > 0 ? 220 : 150),
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width - 220,
                                            padding: EdgeInsets.only(left: 15.0 + deep.toDouble() * 4),
//                                          child: Icon(Icons.phone, color: Colors.black26)
                                            child: Text(
//                                                '${currentTask.title} (${currentTask.activeSubTasksAmount}/${currentTask.subTasksAmount ?? 0}/${currentTask.id})',
                                                '${currentTask.title} ${taskHint()}',
                                                style: TextStyle(fontSize: 16 - deep.toDouble(),
                                                    color: Colors.black54.withAlpha(100 - deep * 10))
                                            ),
                                        ),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [

                                                /// ADD
                                                GestureDetector(
                                                    child: const Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                                                        child: Card(
                                                            shadowColor: Colors.transparent,
                                                            color: btnColors,
                                                            shape: CircleBorder(),
                                                            child: Padding(
                                                                padding: EdgeInsets.all(6.0),
                                                                child: Icon(Icons.add, color: Colors.black26),
                                                            )
                                                        ),
                                                    ),
                                                    onTap: () =>
                                                        subTaskCreateAction?.call(onApply: (Task task) {
                                                            setState(() => expandedCache.add(task));
                                                        }),
                                                ),

//                                                Container(
//                                                    decoration: BoxDecoration(
//                                                        borderRadius: BorderRadius.circular(32),
////                                                       color: Colors.orange,
//                                                        boxShadow: const [
//                                                            BoxShadow(color: Colors.white, spreadRadius: 8),
//                                                        ],
//                                                    ),
//                                                    child: GestureDetector(
//                                                        child: const Padding(
//                                                            padding: EdgeInsets.symmetric(horizontal:4.0),
//                                                            child: Card(
//                                                                shape: CircleBorder(),
//                                                                child: Icon(Icons.add, color: Colors.black26)
//                                                            ),
//                                                        ),
//                                                        onTap: () => subTaskCreateAction?.call(onApply: (Task task) {
//                                                                setState(() => expandedCache.add(task));
//                                                            }
//                                                        ),
//                                                    ),
//                                                ),

                                                /// EDIT
                                                Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            shape: MaterialStateProperty.resolveWith((states) => const CircleBorder()),
                                                            shadowColor: MaterialStateProperty.resolveWith((states) =>
                                                            Colors.transparent),
                                                            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                                                return states.contains(MaterialState.pressed)
                                                                    ? Colors.lightBlueAccent
                                                                    : const Color(0xffEEEEEE);
//                                                                    : Colors.black12;
                                                            },
                                                            )
                                                        ),

                                                        /// expand
//                                                    child: const Icon(Icons.expand_less, color: Colors.black26),
                                                        child: const Icon(Icons.edit_outlined, color: Colors.black26),
                                                        onPressed: () {
                                                            void Function(Task?) onPop = onTap();

                                                            Navigator.push(
                                                                rootContext,
//                                                              MaterialPageRoute(builder: (context) => TaskPage(subContextWrapper, title: users[index]))
                                                                PageRouteBuilder(
//                                                                pageBuilder: (context, animation, secondaryAnimation) => TaskPage(subContextWrapper, title: users[index], onPop: onPop,),
                                                                    pageBuilder: (rootContext, animation,
                                                                        secondaryAnimation)
                                                                    =>
                                                                        TaskEditPage(
                                                                            subContextWrapper,
                                                                            index: index,
                                                                            tasks: tasks,
                                                                            onPop: onPop,
                                                                        ),
                                                                    transitionsBuilder: instantTransition,
                                                                )
                                                            );
                                                        },
                                                    ),
                                                ),
                                            ],
                                        )
                                    ],
                                ),
                                if (currentTask.deadline != null)
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                            Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
                                                child: Text(
                                                    DateFormat("dd.MM E y").format(currentTask.deadline!),
                                                    style: const TextStyle(color: Colors.black26, fontSize: 13),
                                                ),
                                            ),
                                        ],
                                    )
                            ],
                        ),
//                    children: const [
//                        Text('Parent element is not defined')
//                    ],
                        children: [
                            ListView.separated(
                                key: PageStorageKey<String>(rootIndex!.toString()),
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8),
//                                itemCount: tasks[index].subTasksAmount ?? 0,
                                itemCount: expandedCache.length,
                                separatorBuilder: (BuildContext context, int _index) => const Divider(),
                                itemBuilder: (BuildContext context, int _index) {
//                                return parent?.listTileGenerate(index) ?? const Text('Parent element is not defined');

//                                    var children = tasks[index].children;

                                    return parent?.listTileGenerate(
                                        context, _index, widget: self.widget.page,
                                        stateUpdate: setState,
                                        parentTasks: expandedCache,
                                        deep: deep + 1,
                                        parentTask: currentTask
                                    ) ?? Padding(
                                        padding: const EdgeInsets.only(left: 32),
                                        child: Text(expandedCache[_index].title,
                                            style: const TextStyle(fontSize: 12, color: Colors.black54),),
                                    );
//                                    return Padding(
//                                      padding: const EdgeInsets.only(left: 32, bottom: 3, top: 3),
//                                      child: Text(expandedCache[_index].title, style: const TextStyle(fontSize: 14, color: Colors.black54),),
//                                    );
                                }
                            )
                        ],
                    ),
                ),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        var item = _createListViewPoint(context, this);
        return item;
//        return Text(widget.index.toString());
    }
}


Widget createListViewPoint(BuildContext context, int index, {

    List<BuildContext?>? subContextWrapper,
    SwipeBackground? toLeft,
    SwipeBackground? toRight,
    required List<Task> tasks,
    required Function(DismissDirection) onDismissed,
    Future<bool> Function(DismissDirection)? confirmDismiss,
    required Function(Task?) Function() onTap,
    Function? subTaskCreateAct,
    Function? expandAction,
    IExpandedTaskList? parent,
    required BuildContext rootContext})
{
    List<Task> expandedCache = [];

    return Dismissible(
//      key: Key(index.toString()),
        key: UniqueKey(),
        onDismissed: onDismissed,
        confirmDismiss: confirmDismiss,
        secondaryBackground: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            color: toLeft?.color ?? Colors.red,
            alignment: Alignment.centerRight,
            child: toLeft?.icon ?? const Icon(Icons.cancel),
        ),
        background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            color: toRight?.color ?? Colors.green,
            alignment: Alignment.centerLeft,
            child: toRight?.icon ?? const Icon(Icons.check),
        ),
        child: GestureDetector(
            onTap: () {
                void Function(Task?) onPop = onTap();

                Navigator.push(
                    rootContext,
//                MaterialPageRoute(builder: (context) => TaskPage(subContextWrapper, title: users[index]))
                    PageRouteBuilder(
//                    pageBuilder: (context, animation, secondaryAnimation) => TaskPage(subContextWrapper, title: users[index], onPop: onPop,),
                        pageBuilder: (rootContext, animation, secondaryAnimation) =>
                            TaskEditPage(
                                subContextWrapper,
                                index: index,
                                tasks: tasks,
                                onPop: onPop,
                            ),
                        transitionsBuilder: instantTransition,
                    )
                );
            },
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 1),
                padding: const EdgeInsets.symmetric(vertical: 6),
//            color: index == selectedIndex ? Colors.white60: Colors.white60,
                color: Colors.white70,
                child: ListTile(
//                    onExpansionChanged: (bool expanded) async {
//                        if (expanded && tasks[index].subTasksAmount != expandedCache.length) {
//                            expandedCache = (await tasks[index].children) ?? [];
//                        }
//                    },
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 12.0),
//                      child: Icon(Icons.phone, color: Colors.black26)
                                child: Text(
//                                    '${tasks[index].title} (${tasks[index].parentName ?? ''})',
                                    '${tasks[index].title} ${tasks[index].parentName != null
                                        ? '(${tasks[index].parentName})'
                                        : ''}',
                                    style: const TextStyle(fontSize: 16, color: Colors.black54)
                                ),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: GestureDetector(

//                                            child: const Icon(Icons.expand_less, color: Colors.black26),
                                            child: Text(
//                                                tasks[index].deadline.toString(),
                                                tasks[index].deadline != null ? DateFormat("H:m M E d").format(
                                                    tasks[index].deadline!) : '',
                                                style: const TextStyle(fontSize: 12, color: Colors.black38)
                                            ),
                                            onTap: () {},
                                        ),
                                    ),
                                ],
                            )
                        ],
                    ),
//                    children: const [
//                        Text('Parent element is not defined')
//                    ],
//                    children: [
//                        ListView.separated(
//                            shrinkWrap: true,
//                            padding: const EdgeInsets.all(8),
//                            itemCount: tasks[index].subTasksAmount ?? 0,
//                            separatorBuilder: (BuildContext context, int index) => const Divider(),
//                            itemBuilder: (BuildContext context, int index) {
////                                return parent?.listTileGenerate(index) ?? const Text('Parent element is not defined');
////                                return const Text('Parent element is not defined');
//                                return Text(expandedCache[index].title);
//                            }
//                        )
//                    ],
                ),
            ),
        ),
    );
}


/// альтернативная реализация ListViewItem
class TaskItemView extends StatefulWidget {

    final int deep;
    final int index;
    final List<BuildContext?>? subContextWrapper;
    final SwipeBackground? toLeft;
    final SwipeBackground? toRight;
    final List<Task> tasks;
    final Function(DismissDirection) onDismissed;
    final Future<bool> Function(DismissDirection)? confirmDismiss;
    final Function(Task?) Function() onTap;
    final void Function({void Function(Task)? onApply})? subTaskCreateAction;
    final Function? expandAction;
    final IExpandedTaskList? parent;
    final BuildContext rootContext;
    final Task? parentTask;

    const TaskItemView(this.index, {
        Key? key,
        required this.subContextWrapper,
        required this.toLeft,
        required this.toRight,
        required this.tasks,
        required this.onDismissed,
        required this.confirmDismiss,
        required this.onTap,
        required this.subTaskCreateAction,
        required this.expandAction,
        required this.parent,
        required this.rootContext,
        this.parentTask,
        this.deep = 0
    }) : super(key: key);


    @override
    State<StatefulWidget> createState() {
        return TaskItemViewState();
    }
}

class TaskItemViewState extends State<TaskItemView> {
    @override
    Widget build(BuildContext context)
    {
        return Text(widget.index.toString());
    }

}