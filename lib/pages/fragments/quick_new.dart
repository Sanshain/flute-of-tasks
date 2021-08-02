import 'package:flutter/material.dart';


typedef TextEvent = Function(String text);


Positioned createQuickTask({required TextEvent onSubmitted, required TextEvent onChanged, required void Function() onPressed}) {
    return Positioned(
        top: 50,
//                        width: MediaQuery.of(context).size.width,
        height: 150.0,
        left: 15.0,
        right: 15.0,
        child: Container(
            color: Colors.white,
//                            decoration: BoxDecoration(
//                                border: Border.all(color: Colors.greenAccent)
//                            ),
            child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                            restorationId: 'quickNew',
                            onSubmitted: onSubmitted,
//                            onSubmitted: (String text){
//                                newTaskName = null;
//                                setState((){
//                                    if (text.isNotEmpty) tasks.insert(0, Task(text));
//                                    quickNew = false;
//                                });
//                            },
                            onChanged: onChanged,
//                            onChanged: (String text){
//                                newTaskName = text;
//                            },
                            autofocus: true,
                            style: const TextStyle(fontSize: 22, color: Colors.black54),
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(fontSize: 20.0, color: Colors.black26),
                                hintText: 'Enter title of new task'
                            ),
                        ),
                    ),
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
                                    child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("save", style: TextStyle(fontSize: 16)),
                                    )
                                ),
                            ),
                            onPressed: onPressed,
//                            onPressed: () {
//                                setState((){
////                                        users.add('value');
////                                      ???
//                                    if (newTaskName != null && newTaskName!.isNotEmpty) tasks.insert(0, Task(newTaskName!));
//                                    quickNew = false;
//                                });
//                                  Navigator.pop(context);
//                            },
                        ),
                    )
                ],
            )
        )
    );
}