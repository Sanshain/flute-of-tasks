import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanshain_tasks/models/dao/tasks_dao.dart';
import 'package:sanshain_tasks/models/tasks.dart';
import 'package:sanshain_tasks/pages/input_page.dart';
import 'package:sanshain_tasks/pages/places_page.dart';
import 'package:sanshain_tasks/widgets/popups.dart';
import '../models/database/database.dart';

import '../controller.dart';

class PlacedTasksPage extends PlacesPage {

    const PlacedTasksPage({Key? key}) : super(key: key, pageTitle: "");

    @override Widget buildFloatingActionButton(BuildContext context, Controller controller, {double bottom = 15}) {
        return super.buildFloatingActionButton(context, controller, bottom: 50);
    }

    @override
    Widget itemBuilder(BuildContext context, Controller controller, int index) {
        Future dismissAction(DismissDirection direction, int _index) async {
            if (direction == DismissDirection.startToEnd) {
                var archiveTask = controller.places[index].activeTasks[_index];

                archiveTask.isDone = true;
                await Task.tasks?.updateItem(archiveTask);

                controller.places[index].activeTasks.removeAt(_index);
//                popup(context, 'to add archiveTask to archive state');
            }
        }

        return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {},
            background: Container(padding: const EdgeInsets.symmetric(horizontal: 12.0),
                color: Colors.deepOrangeAccent,
                alignment: Alignment.centerLeft,
                child: const Icon(Icons.delete),
            ),
            child: Obx(() =>
                ExpansionTile(
                    title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Text(controller.places[index].name),
//                                Obx(
//                                        () => Text(" (${controller.places[index].tasksAmount} / ${controller.places[index].activeTasks.length})")
//                                ),
                                Obx(() =>
                                    Text(" (${controller.places[index].tasksAmount})")
                                ),
//                                Text(" (${${controller.places[index].activeTasks.length})"),
                            ],
                        ),
                    ),
                    children: [
                        Obx(() =>
                            ListView.builder(
                                key: PageStorageKey<String>(controller.places[index].name),
                                shrinkWrap: true,
                                itemCount: controller.places[index].activeTasks.length,
                                itemBuilder: (context, int _index) {
                                    return Dismissible(
                                        key: UniqueKey(),
                                        onDismissed: (DismissDirection direction) async => await dismissAction(direction, _index),
                                        background: Container(padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                            color: Colors.orange,
                                            alignment: Alignment.centerLeft,
                                            child: const Icon(Icons.archive),
                                        ),
//                                        child: ListTile(
//                                            title: Container(
////                                                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
//                                                color: Colors.red,
//                                                child: Text(controller.places[index].activeTasks[_index].title)
//                                            ),
//                                        )
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12),
                                                    child: Text(controller.places[index].activeTasks[_index].title),
                                                )
                                            ),
//                                          child: Material(
//                                              elevation: 4.0,
//                                              borderRadius: BorderRadius.circular(5.0),
////                                            color: index % 2 == 0 ? Colors.cyan : Colors.deepOrange,
////                                              color: Colors.cyan,
//                                              child: Align(
//                                                  alignment: Alignment.centerLeft,
//                                                  child: Padding(
//                                                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12),
//                                                      child: Text(controller.places[index].activeTasks[_index].title),
//                                                  )
//                                              ),
//                                          ),
                                        ),
                                    );
                                }
                            )
                        )
                    ],
                    onExpansionChanged: (bool expanded) async {
                        if (expanded) {
                            controller.places[index].activeTasks = (await controller.places[index].tasks) ?? <Task>[];
                        }
                    }
                )
            ),
        );
    }

}
