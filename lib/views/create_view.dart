import 'package:flutter/material.dart';
import 'package:some_app/task_view.dart';


class TaskEdit extends TaskPage {
//  const TaskPage({Key? key, required this.title}) : super(key: key);

    const TaskEdit(taskContext, {Key? key, required title}) : super(taskContext, key: key, title: title);

    @override
    State<TaskEdit> createState() => TaskEditState();
}


class TaskEditState extends State<TaskEdit> {

    @override
    Widget build(BuildContext context) {

        widget.taskContext![0] = context;

        return WillPopScope(
            onWillPop: () async {
                Navigator.of(context).pop();
                return false;
            },
            child: Scaffold(
                appBar: AppBar(
                    title: Text(widget.title.isNotEmpty ? widget.title : 'new task'),
                ),
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
//                        Text(
//                            'Your tas is:',
//                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                              autofocus: true,
                              style: TextStyle(fontSize: 22, color: Colors.blue),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                      )
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                  hintStyle: TextStyle(fontSize: 20.0, color: Colors.black26),
                                  hintText: "Title"
                              ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                                style: TextStyle(fontSize: 22, color: Colors.blue),
                                maxLines: 10,
                                minLines: 5,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                        )
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                    hintStyle: TextStyle(fontSize: 20.0, color: Colors.black26),
                                    hintText: "Description"
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}