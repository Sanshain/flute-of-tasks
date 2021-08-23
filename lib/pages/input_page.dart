//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller.dart';


class InputPage extends StatelessWidget {

    const InputPage({Key? key, this.initValue = '', this.title = ''}) : super(key: key);

    final String title;
    final String initValue;

    @override
    Widget build(context) {
        // Instantiate your class using Get.put() to make it available for all "child" routes there.
        final Controller controller = Get.find();

        final TextEditingController inputController = TextEditingController(text: initValue);

        return WillPopScope(
            onWillPop: () async {
                Navigator.of(context).pop(inputController.text);
                return false;
            },
            child: Scaffold(
                // Use Obx(()=> to update Text() whenever count is changed.
//            appBar: AppBar(title: Obx(() => Text("Clicks: ${c.count}"))),
                appBar: title.isNotEmpty ? AppBar(title: Text(title)) : null,

                // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
//            body: Center(child: ElevatedButton(
//                child: Text("Go to Other"), onPressed: () => Get.to(Other()))
//            ),

                body: TextField(
                    controller: inputController,
//                    initialValue: '',
                    autofocus: true,
                    maxLines: 1,
                    minLines: 1,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    onChanged: (String text) {},
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black38, width: 2.0),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0))
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                        hintStyle: TextStyle(fontSize: 20.0, color: Colors.black26),
                        hintText: 'enter task name'
                    ),
                ),
                floatingActionButton: Container(
                    padding: EdgeInsets.only(bottom: 40.0, right: MediaQuery
                        .of(context)
                        .size
                        .width / 2 - 50),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton.extended(
                            onPressed: () => Navigator.of(context).pop(inputController.text),
                            label: Row(
                                children: const [
                                    Text('Save'),
                                    Icon(Icons.save, color: Colors.white,),
                                ],
                            ),
                            backgroundColor: Colors.black12,
//                          child: const Icon(Icons.save, color: Colors.white,),
                        )
                    )
                ),
            ),
        );
    }
}
