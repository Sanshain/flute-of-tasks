import 'package:flutter/material.dart';
import 'package:some_app/task_view.dart';
import 'package:some_app/widgets/fields.dart';


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
                    children: <Widget>[
//                        Text(
//                            'Your tas is:',
//                        ),
                        inputField(hint: 'Title', autofocus: true),
                        inputField(hint: 'Description', minLines: 5, maxLines: 10),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black38,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                    )
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text("save", style: TextStyle(fontSize: 16))
                                  ),
                                ),
                                onPressed: () {
                                    Navigator.of(context).pop();
                                }
                            ),
                        )
                    ],
                ),
            ),
        );
    }
}