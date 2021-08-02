import 'package:flutter/material.dart';
import 'package:some_app/models/tasks.dart';
import 'package:some_app/task_view.dart';
import 'package:some_app/widgets/button.dart';
import 'package:some_app/widgets/fields.dart';
import 'package:some_app/widgets/popups.dart';


class TaskEdit extends TaskPage {
//  const TaskPage({Key? key, required this.title}) : super(key: key);

     TaskEdit(taskContext, {Key? key, required this.index, required this.tasks, Function(Task?)? onPop}) : super(
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
        DateTime selectedDate;
        Task? updated;

        return WillPopScope(
            onWillPop: () async {
                if (widget.onPop != null) await widget.onPop!(updated);
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
                          minLines: 4, maxLines: 10,
                        //                              autofocus: widget.task.description.isEmpty,
                          onChanged: (String text) {
                              updated = updated ?? widget.task;
                              widget.task.description = text;
                          }
                        ),
                        Center(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                    Text("${widget.task.deadline ?? ''}".split(' ')[0]),
                                    const SizedBox(height: 20.0,),
                                    ElevatedButton(
                                        onPressed: () => selectDate(
                                            context, null,
                                            setState: (datetime){
//                                                selectedDate = datetime;
                                                updated = updated ?? widget.task;
                                                setState(() {
                                                    widget.task.deadline = datetime;
                                                });
                                            }
                                        ),
                                        child: const Text('Select date'),
                                    ),
                                ],
                            ),
                        ),
                        StyledButton('save', onPress:() async {
                            widget.onPop?.call(updated);
//                            await widget.onPop != null?(updated);
                        })
                      ],
                  ),
                ),
            ),
        );
    }
}