import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:some_app/models/tasks.dart';
import 'package:some_app/pages/task_edit_page.dart';
import 'package:some_app/transitions/instant.dart';
import 'package:some_app/widgets/popups.dart';


//typedef ChangeState = Function Function();


class SwipeBackground {

    const SwipeBackground(this.color, this.icon);

    final Color color;
    final Icon icon;
}


Widget createListViewPoint(BuildContext context, int index, {
    List<BuildContext?>? subContextWrapper,
    SwipeBackground? toLeft,
    SwipeBackground? toRight,
    required List<Task> tasks,
    required Function(DismissDirection) onDismissed,
    Future<bool> Function(DismissDirection)? confirmDismiss,
    required Function(Task?) Function() onTap,
    Function? subTaskCreateAction,
    Function? expandAction,
    required BuildContext rootContext,}) {
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
                                                subTaskCreateAction?.call();
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
                    children: [
                        ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemCount: tasks.length,
                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                            itemBuilder: (BuildContext context, int index)
                        )
                    ],
                ),
            ),
        ),
    );
}