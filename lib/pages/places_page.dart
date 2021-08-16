import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:some_app/models/dao/tasks_dao.dart';
import 'package:some_app/models/tasks.dart';
import 'package:some_app/pages/input_page.dart';
import 'package:some_app/widgets/popups.dart';
import '../models/database/database.dart';

import '../controller.dart';

class PlacesPage extends StatelessWidget {

    const PlacesPage({Key? key, this.pageTitle = "Places"}) : super(key: key);

    final String pageTitle;

    Widget itemBuilder(BuildContext context, Controller controller, int index){

        return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
                popup(context, 'todo');
            },
            background: Container(padding: const EdgeInsets.symmetric(horizontal: 12.0),
                color: Colors.deepOrangeAccent,
                alignment: Alignment.centerLeft,
                child: const Icon(Icons.delete),
            ),
            child: GestureDetector(
                onTap: () async {
                    String placeName = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => InputPage(initValue: controller.places[index].name))
                    );
                    if (placeName.isNotEmpty) {
                        var place = Place(controller.places[index].id, placeName, true);
                        controller.places[index] = place;
                        await Place.objects?.updateItem(place);
                    }
                },
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(controller.places[index].name),
                ),
            ),
        );
    }

    @override
    Widget build(context) {
        // Instantiate your class using Get.put() to make it available for all "child" routes there.
        final Controller controller = Get.find();

        buildItem(_context, index) => itemBuilder(_context, controller, index);

        return WillPopScope(
            onWillPop: () async {
                return true;
            },
            child: Scaffold(
                // Use Obx(()=> to update Text() whenever count is changed.
//            appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),
                appBar: pageTitle.isNotEmpty ? AppBar(title: Text(pageTitle)) : null,

                // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
//            body: Center(child: ElevatedButton(
//                child: Text("Go to Other"), onPressed: () => Get.to(Other()))
//            ),

                body: Obx(() =>
                    ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: controller.places.length,
                        itemBuilder: buildItem,
                    )
                ),
                floatingActionButton: buildFloatingActionButton(context, controller),
            ),
        );
    }

    Widget buildFloatingActionButton(BuildContext context, Controller controller) {
      return Container(
          padding: const EdgeInsets.only(bottom: 15.0, right: 15.0),
          child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                  onPressed: () async {
                      String placeName = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const InputPage())
                      );
                      if (placeName.isNotEmpty) {
                          var place = Place.init(placeName);
//                                    controller.places.add(place);
                          controller.appendPlace(place);
                          await Place.objects?.insertNew(place);
                      }
//                                popup(context, placeName);
                  },
                  child: const Icon(Icons.add),
              )
          )
      );
    }
}
