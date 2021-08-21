import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:some_app/controller.dart';
import 'package:some_app/models/tasks.dart';
import 'package:some_app/task_view.dart';
import 'package:some_app/widgets/button.dart';
import 'package:some_app/widgets/fields.dart';
import 'package:some_app/widgets/popups.dart';

import 'fragments/grvity_handler.dart';


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

        final Controller controller = Get.find();
        final TextEditingController inputController = TextEditingController(text: '');

        widget.taskContext![0] = context;

        String? placeName;
        Task? updated;

        if (widget.task.place != null) {
            var _place = controller.places
                .where((p0) => p0.id == widget.task.place)
                .first;
            placeName = _place.name;
        }

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
                                updated = updated ?? widget.task;
                                widget.task.title = text;
                            }),
                            inputField(hint: 'Description',
                                value: widget.task.description,
                                minLines: 4,
                                maxLines: 10,
                                //                              autofocus: widget.task.description.isEmpty,
                                onChanged: (String text) {
                                    updated = updated ?? widget.task;
                                    widget.task.description = text;
                                }
                            ),
                            Container(
                                height: 96,
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        // RATE INCREASE

                                        /// IMPORTANCE VIEW
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
//                                                const Padding(
//                                                  padding: EdgeInsets.all(8.0),
//                                                  child: Text("Важность"),
//                                                ),
                                                GestureDetector(
                                                    onTap: () async {
                                                        int? gravity = await increasingDialog(
                                                            context, value: widget.task.gravity, title: "Set importance"
                                                        );
                                                        if (gravity != null) {
//                                                            updated = updated ?? widget.task;
                                                            setState(() => widget.task.gravity = gravity);
                                                            Task.tasks?.updateItem.call(widget.task);
                                                        }
                                                    },
                                                    child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(30.0),
                                                        child: Container(
                                                            color: Colors.black12,
                                                            width: 50,
                                                            height: 50,
                                                            child: Center(child: Text(widget.task.gravity.toString()),)
                                                        )
                                                    ),
                                                ),
                                            ],
                                        ),

                                        /// DATETIME VIEW
                                        Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
//                                                Text("${widget.task.deadline ?? ''}".split(' ')[0]),
//                                                const SizedBox(height: 20.0,),
                                                ElevatedButton(
//                                                    ElevatedButton.styleFrom(primary: Colors.red)
                                                    style: ButtonStyle(
                                                        shape: MaterialStateProperty.resolveWith((states) => const RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(Radius.circular(25.0))
                                                        )),
                                                        shadowColor:  MaterialStateProperty.resolveWith((states) => Colors.transparent),
                                                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                                (Set<MaterialState> states) {
                                                                    if (states.contains(MaterialState.pressed)) { return Colors.lightBlueAccent; }
                                                                    return Colors.black26;
                                                                },
                                                            )
                                                        ),
                                                    onPressed: () =>
                                                        selectDate(
                                                            context, null,
                                                            setState: (datetime) {
//                                                              selectedDate = datetime;
                                                                updated = updated ?? widget.task;
                                                                setState(() {
                                                                    widget.task.deadline = datetime;
                                                                });
                                                            }
                                                        ),
                                                    child: Text(
                                                        widget.task.deadline != null
                                                            ? DateFormat("dd.MM E y").format(widget.task.deadline!)
                                                            : 'Select date',
                                                        style: const TextStyle(decorationColor: Colors.red),
                                                    ),
                                                ),
                                            ],
                                        ),

                                        /// LOCATION VIEW
                                        Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                                Text(placeName ?? '-'),
//                                            const SizedBox(height: 20.0,),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        fixedSize: const Size(30, 30),
                                                        shape: const CircleBorder(),
////                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                                        shadowColor: Colors.transparent,
                                                        primary: Colors.black12
                                                    ),
                                                    onPressed: () async {
                                                        var prePlace = widget.task.place;

                                                        var location = await choiceDialog(
                                                            context, controller.places.map((p) => p.name),
                                                            title: 'Select task location'
                                                        );

                                                        var place = controller.places
                                                            .where((p0) => p0.name == location)
                                                            .firstOrNull;

                                                        if (prePlace != place?.id) {
//                                                            updated = updated ?? widget.task;
                                                            setState(() => placeName = place?.name ?? 'is not specified');

                                                            widget.task.place = place?.id;
                                                            widget.task.save();
                                                        }
                                                    },
                                                    child: const Icon(Icons.place),
                                                ),
                                            ],
                                        ),
                                    ],
                                ),
                            ),

                            StyledButton('save',
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                                onPress: () async {
                                    widget.onPop?.call(updated);
//                                    await widget.onPop != null?(updated);
                                }
                            )
                        ],
                    ),
                ),
            ),
        );
    }
}
