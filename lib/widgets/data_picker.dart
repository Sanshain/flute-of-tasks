import 'package:flutter/material.dart';

Future simpleDialogWithOption(BuildContext context, Iterable<String> choices, Function callback) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
            return SimpleDialog(
                title: const Text('Title'),
                children: [
                    for (var choice in choices)
                        SimpleDialogOption(
                            onPressed: () {
                                callback(choice);
                                Navigator.pop(context);
                            },
                            child: Text(choice),
                        ),
                ],
//                children: <Widget>[
//                    SimpleDialogOption(
//                        onPressed: () {
//                            Navigator.pop(context);
//                        },
//                        child: const Text('First Option'),
//                    ),
//                    SimpleDialogOption(
//                        onPressed: () {
//                            Navigator.pop(context);
//                        },
//                        child: const Text('Second Option'),
//                    ),
//                    SimpleDialogOption(
//                        onPressed: () {
//                            Navigator.pop(context);
//                        },
//                        child: const Text('Other Option'),
//                    )
//                ],
            );
        });
}