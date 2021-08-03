import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:some_app/models/tasks.dart';
import 'package:some_app/pages/task_edit_page.dart';
import 'package:some_app/transitions/instant.dart';
import 'package:some_app/widgets/popups.dart';


//typedef ChangeState = Function Function();


abstract class IExpandedTaskList {
    Widget listTileGenerate(int index);
}


class SwipeBackground {

    const SwipeBackground(this.color, this.icon);

    final Color color;
    final Icon icon;
}


class ListViewItem extends StatefulWidget {

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

    const ListViewItem(BuildContext context, this.index, {
        key,
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
        required this.rootContext}) : super(key: key);

    @override
    ListViewItemState createState() => ListViewItemState();
}


class ListViewItemState extends State<ListViewItem> {

    int? rootIndex;
    List<Task> expandedCache = [];

    @override
    void initState() {
        super.initState(); //      Future.delayed(Duration.zero,() { });

    }

    Widget _createListViewPoint(BuildContext context, ListViewItemState self)
    {
        var widget = self.widget;

        int index = widget.index;
        rootIndex = index;
        List<BuildContext?>? subContextWrapper = widget.subContextWrapper;
        SwipeBackground? toLeft = widget.toLeft;
        SwipeBackground? toRight = widget.toRight;
        List<Task> tasks = widget.tasks;
        Function(DismissDirection) onDismissed = widget.onDismissed;
        Future<bool> Function(DismissDirection)? confirmDismiss = widget.confirmDismiss;
        Function(Task?) Function() onTap = widget.onTap;
//        Function(Function(Task)?)? subTaskCreateAction = widget.subTaskCreateAction;
        Function({Function(Task)? onApply})? subTaskCreateAction = widget.subTaskCreateAction;
        Function? expandAction = widget.expandAction;
        IExpandedTaskList? parent = widget.parent;
        BuildContext rootContext = widget.rootContext;


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

                },
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 1),
                    padding: const EdgeInsets.symmetric(vertical: 1),
//            color: index == selectedIndex ? Colors.white60: Colors.white60,
                    color: Colors.white60,
                    child: ExpansionTile(
                        key: PageStorageKey<String>(rootIndex!.toString()),
//                        key: Key(index.toString()),
                        onExpansionChanged: (bool expanded) async {

                            var startAmount = tasks[index].subTasksAmount;

                            if (expanded && startAmount != expandedCache.length) {
//                                expandedCache = (await tasks[index].children) ?? [];
                                var _index = index;
                                var subTasks = (await tasks[_index].children) ?? [];
                                setState(() {
//                                    expandedCache = expandedCache;
//                                    expandedCache = subTasks;
                                    expandedCache.insertAll(expandedCache.length, subTasks);
                                });
                            }
                        },
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
//                      child: Icon(Icons.phone, color: Colors.black26)
                                    child: Text(
                                        '${tasks[index].title} (${tasks[index].subTasksAmount})',
                                        style: const TextStyle(fontSize: 16, color: Colors.black54)
                                    ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        Container(
                                            decoration: const BoxDecoration(
//                                        borderRadius: BorderRadius.circular(16),
//                                        color: Colors.orange,
                                                boxShadow: [
                                                    BoxShadow(color: Colors.white, spreadRadius: 8),
                                                ],
                                            ),
                                            child: GestureDetector(

                                                /// add
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                                  child: Icon(Icons.add, color: Colors.black26),
                                                ),
                                                onTap: () {
//                                            popup(context, 'content');
                                                    subTaskCreateAction?.call(onApply: (Task task){
                                                        setState(() {
                                                          expandedCache.add(task);
                                                        });
                                                    });
                                                },
                                            ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                            child: GestureDetector(

                                                /// expand
//                                                child: const Icon(Icons.expand_less, color: Colors.black26),
                                                child: const Icon(Icons.edit_outlined, color: Colors.black26),
                                                onTap: () {
                                                    void Function(Task?) onPop = onTap();

                                                    Navigator.push(
                                                        rootContext,
//                                                      MaterialPageRoute(builder: (context) => TaskPage(subContextWrapper, title: users[index]))
                                                        PageRouteBuilder(
//                                                          pageBuilder: (context, animation, secondaryAnimation) => TaskPage(subContextWrapper, title: users[index], onPop: onPop,),
                                                            pageBuilder: (rootContext, animation, secondaryAnimation) =>
                                                                TaskEdit(
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

//                                    return parent?.listTileGenerate(_index) ?? Padding(
//                                        padding: const EdgeInsets.only(left: 32),
//                                        child: Text(expandedCache[_index].title, style: const TextStyle(fontSize: 12, color: Colors.black54),),
//                                    );
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 32, bottom: 3, top: 3),
                                      child: Text(expandedCache[_index].title, style: const TextStyle(fontSize: 14, color: Colors.black54),),
                                    );
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
    required BuildContext rootContext}) {
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
                            TaskEdit(
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
                padding: const EdgeInsets.symmetric(vertical: 16),
//            color: index == selectedIndex ? Colors.white60: Colors.white60,
                color: Colors.white60,
                child: ExpansionTile(
                    onExpansionChanged: (bool expanded) async {
                        if (expanded && tasks[index].subTasksAmount != expandedCache.length) {
                            expandedCache = (await tasks[index].children) ?? [];
                        }
                    },
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 15.0),
//                      child: Icon(Icons.phone, color: Colors.black26)
                                child: Text(
                                    '${tasks[index].title} (${tasks[index].subTasksAmount})',
                                    style: const TextStyle(fontSize: 16, color: Colors.black54)
                                ),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                    Container(
                                        decoration: const BoxDecoration(
//                                        borderRadius: BorderRadius.circular(16),
//                                        color: Colors.orange,
                                            boxShadow: [
                                                BoxShadow(color: Colors.white, spreadRadius: 8),
                                            ],
                                        ),
                                        child: GestureDetector(

                                            /// add
                                            child: const Icon(Icons.add, color: Colors.black26),
                                            onTap: () {
//                                            popup(context, 'content');
                                                subTaskCreateAct?.call();
                                            },
                                        ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: GestureDetector(

                                            /// expand
                                            child: const Icon(Icons.expand_less, color: Colors.black26),
                                            onTap: () {

                                            },
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
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: tasks[index].subTasksAmount ?? 0,
                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                            itemBuilder: (BuildContext context, int index) {
//                                return parent?.listTileGenerate(index) ?? const Text('Parent element is not defined');
//                                return const Text('Parent element is not defined');
                                return Text(expandedCache[index].title);
                            }
                        )
                    ],
                ),
            ),
        ),
    );
}