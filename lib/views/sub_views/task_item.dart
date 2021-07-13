import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:some_app/models/tasks.dart';
import 'package:some_app/transitions/instant.dart';

import '../create_view.dart';


//typedef ChangeState = Function Function();



Widget createListViewPoint(BuildContext context, int index, {
                            List<BuildContext?>? subContextWrapper,
                            required List<Task> tasks,
                            required Function(DismissDirection) onDismissed,
                            required Future<bool> Function(DismissDirection) confirmDismiss,
                            required Function Function() onTap,
                            required BuildContext rootContext,}) {

    return Dismissible(
//      key: Key(index.toString()),
      key: UniqueKey(),
      onDismissed: onDismissed,
      confirmDismiss: confirmDismiss,
      child: GestureDetector(
          onTap: () {

              var onPop = onTap();

//            setState(() => inDetail = true );
//            void onPop () {
//                setState(() => inDetail = false);
//            }

              Navigator.push(
                  rootContext,
                  PageRouteBuilder(
//              pageBuilder: (context, animation, secondaryAnimation) => TaskPage(subContextWrapper, title: users[index], onPop: onPop,),
                      pageBuilder: (rootContext, animation, secondaryAnimation) => TaskEdit(
                          subContextWrapper,
                          index: index,
                          tasks: tasks,
                          onPop: onPop,
                      ),
                      transitionsBuilder: instantTransition,
                  )
//            MaterialPageRoute(builder: (context) => TaskPage(subContextWrapper, title: users[index]))
              );

          },
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 1),
              padding: const EdgeInsets.symmetric(vertical: 16),
//            color: index == selectedIndex ? Colors.white60: Colors.white60,
              color: Colors.white60,
              child: Row(
                  children: [
                      const Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: Icon(Icons.phone, color: Colors.black26)
                      ),
                      Text(tasks[index].title, style: const TextStyle(fontSize: 16, color: Colors.black54)),
                  ],
              ),
          ),
      ),
    );
}