import 'package:flutter/material.dart';
import 'package:some_app/models/tasks.dart';
import 'package:some_app/task_view.dart';
import 'package:some_app/widgets/fields.dart';


class TaskEdit extends TaskPage {
//  const TaskPage({Key? key, required this.title}) : super(key: key);

     TaskEdit(taskContext, {Key? key, required this.index, required this.tasks, Function? onPop}) : super(
        taskContext,
        tasks[index],
        key: key,
        onPop: onPop
    );

    final int index;
    final List<Task> tasks;

    @override
    State<TaskEdit> createState() => TaskEditState();
}


class TaskEditState extends State<TaskEdit> {

    var textController = TextEditingController();

    @override
    Widget build(BuildContext context) {

        widget.taskContext![0] = context;

        return WillPopScope(
            onWillPop: () async {
                if (widget.onPop != null) widget.onPop!();
                Navigator.of(context).pop();
                return false;
            },
            child: Scaffold(
                appBar: AppBar(
                    title: Text(widget.task.title.isNotEmpty ? widget.task.title : 'new task'),
                ),
                body: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
//                        Text(
//                            'Your tas is:',
//                        ),
                          inputField(hint: 'Title', value: widget.task.title, onChanged: (String text) {
                              widget.task.title = text;
                          }),
                          inputField(hint: 'Description',
                              value: widget.task.description,
                              minLines: 5, maxLines: 10,
                              autofocus: true, onChanged: (String text) {

                              widget.task.description = text;
                          }),
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
            ),
        );
    }
}