import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sanshain_tasks/controller.dart';
import 'package:sanshain_tasks/models/tasks.dart';
import 'package:sanshain_tasks/task_view.dart';
import 'package:sanshain_tasks/widgets/button.dart';
import 'package:sanshain_tasks/widgets/fields.dart';
import 'package:sanshain_tasks/widgets/popups.dart';

import 'fragments/grvity_handler.dart';
import 'fragments/slider_dialog.dart';


const hoursDayLimit = 2;

class TaskEditPage extends TaskPage {
//  const TaskPage({Key? key, required this.title}) : super(key: key);

    TaskEditPage(taskContext, {Key? key, required this.index, required this.tasks, Function(Task?)? onPop}) : super(
        taskContext,
        tasks[index],
        key: key,
        onPop: onPop
    );

    final int index;
    final List<Task> tasks;

    @override
    State<TaskEditPage> createState() => TaskEditState();


    static ButtonStyle getElevatedButtonStyle({bool left = false}) {
        return ButtonStyle(
            // (states) => const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))
            shape: MaterialStateProperty.resolveWith((states) =>
                RoundedRectangleBorder(borderRadius:
                left ? const BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    topLeft: Radius.circular(25.0)
                ) : const BorderRadius.only(
                    bottomRight: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)
//                    bottomLeft: Radius.circular(25.0),
//                    topLeft: Radius.circular(25.0)
                ))
            ),
            padding: MaterialStateProperty.resolveWith((states) =>
            left
                ? const EdgeInsets.only(left: 10, right: 0)
                : const EdgeInsets.only(left: 0, right: 10)
            ),
//            maximumSize: MaterialStateProperty.resolveWith((states) => const Size(150, 30)),
            shadowColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
            backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                    return Colors.lightBlueAccent;
                }
                return Colors.black26;
            })
        );
    }

}


class TaskEditState extends State<TaskEditPage> {

    var textController = TextEditingController();

    void durUp(_updated) async {
        var delta = widget.task.deadline!.difference(widget.task.created);
        var units = delta.inDays > hoursDayLimit ? TimeUnits.day : TimeUnits.hour;
        var max = units == TimeUnits.day ? delta.inDays : delta.inHours;

        int? value = await sliderDialog(
            context, value: widget.task.duration ?? 0, units: units, options: SliderOptions(max: max), title: 'Duration'
        );
        _updated = _updated ?? widget.task;
        setState(() => widget.task.duration = value);

        await Task.tasks?.updateItem.call(widget.task);
    }

//    var elevatedButtonStyle = TaskEditPage.getElevatedButtonStyle();

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
                                                if (widget.task.deadline != null)
                                                    if (widget.task.duration == null || widget.task.duration == 0)
                                                        IconButton(
                                                            icon: const Icon(Icons.receipt_long, color: Colors.black12,),
                                                            onPressed: () => durUp(updated),
                                                        )
                                                    else
                                                        GestureDetector(
                                                            onTap: () => durUp(updated),
                                                            child: Text('${widget.task.duration} ${
//                                                                widget.task.deadline!.difference(widget.task.created).inDays > hoursDayLimit
                                                                widget.task.deadline!.difference(widget.task.created).inDays > hoursDayLimit
                                                                    ? 'days'
                                                                    : 'hours'
                                                            } inside ${
                                                                widget.task.deadline!.difference(widget.task.created).inDays > hoursDayLimit
                                                                    ? "${widget.task.deadline!.difference(DateTime.now()).inDays} days"
                                                                    : "${widget.task.deadline!.difference(DateTime.now()).inHours} hours"
                                                            }',
                                                                style: const TextStyle(color: Colors.black26)
                                                            ),
                                                        ),
                                                Row(
                                                    children: [
                                                        ElevatedButton(
                                                            style: TaskEditPage.getElevatedButtonStyle(left: true),
                                                            // ElevatedButton.styleFrom(primary: Colors.red)
                                                            onPressed: () =>
                                                                selectDate(context,
                                                                    widget.task.deadline,
                                                                    start: DateTime.now().add(Duration(
                                                                        hours: widget.task.getDuration() ?? 1
                                                                    )),
                                                                    setState: (datetime) {
                                                                        //                                                              selectedDate = datetime;
                                                                        updated = updated ?? widget.task;
                                                                        setState(() {
//                                                                            if (widget.task.deadline != null){
//                                                                                datetime = datetime.add(Duration(hours: widget.task.deadline!.hour));
//                                                                            }
                                                                            widget.task.deadline = datetime.add(
                                                                                Duration(
                                                                                    hours: widget.task.deadline?.hour ?? 0,
                                                                                    minutes: widget.task.deadline?.minute ?? 0,
                                                                                ),
                                                                            );
                                                                        });
                                                                    }
                                                                ),
                                                            child: Text(
                                                                widget.task.deadline != null
                                                                    ? DateFormat("dd.MM E y").format(widget.task.deadline!)
                                                                    : 'Select date',
                                                                style: const TextStyle(decorationColor: Colors.red)
                                                            ),
                                                        ),
                                                        ElevatedButton(
                                                            style: TaskEditPage.getElevatedButtonStyle(),
                                                            child: widget.task.deadline != null &&
                                                                widget.task.deadline!.hour != 0
                                                                ? Text(DateFormat("HH:mm").format(widget.task.deadline!))
                                                                : const Icon(Icons.access_time, color: Colors.white54),
//                                                            icon: const Icon(Icons.access_time),
                                                            onPressed: () async {
                                                                var expirationTime = await showTimePicker(context: context,
                                                                    initialTime: TimeOfDay.fromDateTime(
                                                                        DateTime.now().add(const Duration(hours: 1))
                                                                    ),
                                                                    builder: (context, child) {
                                                                        return MediaQuery(
                                                                            data: MediaQuery.of(context).copyWith(
                                                                                alwaysUse24HourFormat: true
                                                                            ),
                                                                            child: child as Widget,
                                                                        );
                                                                    }
                                                                );
                                                                if (expirationTime != null) {
//                                                                    widget.task.deadline
//                                                                    expirationTime.hour

                                                                    DateTime now = DateTime.now();

                                                                    if (widget.task.deadline == null) {
                                                                        setState(() {
                                                                            widget.task.deadline = DateTime(
                                                                                now.year, now.month,
                                                                                (expirationTime.hour > now.hour
                                                                                    ? now
                                                                                    : DateTime.now().add(const Duration(days: 1))
                                                                                ).day,
                                                                                expirationTime.hour, expirationTime.minute
                                                                            );
                                                                        });
                                                                    }
                                                                    else {

                                                                        var tomorrow = 0;
                                                                        if (widget.task.deadline!.day == now.day && expirationTime.hour < DateTime.now().hour) {
                                                                            tomorrow = 1;
                                                                        }

                                                                        setState(() => widget.task.deadline = DateTime(
                                                                            widget.task.deadline!.year, widget.task.deadline!.month,
                                                                            widget.task.deadline!.day + tomorrow,
                                                                            expirationTime.hour,
                                                                            expirationTime.minute
                                                                        ));
                                                                    }
//                                                                    popup(context, expirationTime.toString());
                                                                }
                                                            }
                                                        )
                                                    ],
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

                                                        int _placeIndex = controller.places
                                                            .indexWhere((element) => element.name == location);

                                                        Place? place = _placeIndex >= 0
                                                            ? controller.places[_placeIndex]
                                                            : null;

//                                                        var place = controller.places
//                                                            .where((p0) => p0.name == location)
//                                                            .firstOrNull;

                                                        if (prePlace != place?.id) {
//                                                            updated = updated ?? widget.task;
                                                            setState(() => placeName = place?.name ?? 'is not specified');
                                                            controller.places[_placeIndex].tasksAmount += 1;

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
