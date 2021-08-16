import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:some_app/models/dao/tasks_dao.dart';
import 'package:some_app/models/tasks.dart';
import 'package:some_app/pages/input_page.dart';
import 'package:some_app/pages/places_page.dart';
import 'package:some_app/widgets/popups.dart';
import '../models/database/database.dart';

import '../controller.dart';

class PlacedTasksPage extends PlacesPage {

    const PlacedTasksPage({Key? key}) : super(key: key, pageTitle: "");

    @override
    Widget itemBuilder(BuildContext context, Controller controller, int index) {

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
                      child: Text(controller.places[index].name),
                    ),
                    children: [
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.places[index].activeTasks.length,
                            itemBuilder: (context, int _index) {
                                return Dismissible(
                                    key: UniqueKey(),
                                    onDismissed: (DismissDirection direction){
                                        if (direction == DismissDirection.startToEnd){

                                            var archiveTask = controller.places[index].activeTasks[_index];
                                            archiveTask.isDone = true;
                                            Task.tasks?.updateItem(archiveTask); // await

                                            controller.places[index].activeTasks.removeAt(_index);
                                            popup(context, 'to add archiveTask to archive state');
                                        }
                                    },
                                    background: Container(padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                        color: Colors.orange,
                                        alignment: Alignment.centerLeft,
                                        child: const Icon(Icons.archive),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(controller.places[index].activeTasks[_index].title),
                                    )
                                );
                            }
                        )
                    ],
                    onExpansionChanged: (bool expanded) async {
                        if (expanded) {
                            controller.places[index].activeTasks = await controller.places[index].tasks ?? <Task>[];
                        }
                    }
                )
            ),
//            child: Obx(() =>
//                ListView.builder(
//                    itemBuilder: (context, _index) {
//                        Task _task = (await controller.places[index].tasks)[_index];
//                        return ExpansionTile(
//                            title: Text(_task.title),
//                        );
//                    },
//                    itemCount: controller.places[index].tasks.length
//                )
//            )
        );
    }
}
