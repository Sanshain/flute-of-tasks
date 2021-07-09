import 'package:flutter/material.dart';

void popup(BuildContext context, String content, {String title = ''}) {
// show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
            return AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: [
                    TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                            Navigator.pop(context);
                        },
                    )
                ],
            );
        },
    );
}


void input(BuildContext context, String content, {String title = ''}) {
// show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
            return Positioned(
                top: 10,
                child: AlertDialog(
                      title: Text(title),
                      content: const SizedBox(
                          height: 50,
                          child: TextField(
                              autofocus: true,
                              style: TextStyle(fontSize: 22, color: Colors.blue),
                          ),
                      ),
                      actions: [
                          TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                  Navigator.pop(context);
                              },
                          )
                      ],
                ),
            );
        },
    );
}