import 'package:flutter/material.dart';
import 'package:some_app/models/tasks.dart';


class TaskPage extends StatefulWidget {
//  const TaskPage({Key? key, required this.title}) : super(key: key);

  TaskPage(this.taskContext, Task _task, {Key? key, this.onPop}) : super(key: key){

    task = _task;
  }

  late final Task task;
  final List<BuildContext?>? taskContext;
  final Function? onPop;

  @override
  State<TaskPage> createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
          title: Text(widget.task.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Your tas is:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 75.0),
          child: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.accessibility),
            backgroundColor: Colors.orange,
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
         floatingActionButtonLocation: FloatingActionButtonLocation.endTop
      ),
    );
  }
}