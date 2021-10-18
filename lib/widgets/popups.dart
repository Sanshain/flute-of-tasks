//import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

///
/// аналог alert
///
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

///
/// My custom input dialog (сдвигается при вызове клавиатуры. неудобно)
///
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

///
/// окно ввода с какого-то интернет-ресурса (не особо отличается от того, что я сделал сам в `input`)
///
Future<String?> inputDialog(BuildContext context, {title = 'Title', label = '', hint = ''}) async {
    String returnValue = '';

    return showDialog(
        context: context,
        barrierDismissible: false, // dialog is dismissible with a tap on the barrier

        builder: (BuildContext context) {
            return AlertDialog(
                title: Text(title),
                content: Row(
                    children: <Widget>[
                        Expanded(
                            child: TextField(autofocus: true,
                                decoration: InputDecoration(labelText: label, hintText: hint),
                                onChanged: (value) => returnValue = value,
                            ))
                    ],
                ),
                actions: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                        child: const Text('Ok'),
                        onPressed: () => Navigator.of(context).pop(returnValue),
                    ),
                ],
            );
        },
    );
}


///
/// окно выбора из нескольких вариантов
///
Future<String?> choiceDialog(BuildContext context, Iterable<String> options, {title = ''}) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
            return SimpleDialog(
                title: Text(title),
                children: [
                    for (var option in options)
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SimpleDialogOption(
                                onPressed: () => Navigator.pop(context, option),
                                child: Text(option),
                            ),
                        )
                ]
            );
        }
    );
}

///
/// show the dialog confirmation in [rootContext]
///
Future<bool?> showConfirmationDialog(BuildContext rootContext, String action, {String title = 'Подтверждение'}) {
    return showDialog<bool>(
        context: rootContext,
        barrierDismissible: true,
//      barrierColor: Colors.lightBlueAccent,
        builder: (BuildContext context) {
            return AlertDialog(
                title: Text(title),
                content: SizedBox(height: 50,
                    child: Text(action,
//                      style: const TextStyle(fontSize: 22, color: Colors.blue),
                    ),
                ),
                actions: [
                    TextButton(child: const Text("OK"),
                        onPressed: () => Navigator.of(context).pop(true),
                    ),
                    TextButton(child: const Text("Cancel"),
                        onPressed: () => Navigator.of(context).pop(false),
                    )
                ],
            );
        },
    );
}


///
/// вызывает окно выбора даты для указанного [context]
///
Future<void> selectDate(BuildContext context, DateTime? selectedDate,
    {
        required Function(DateTime) setState, DateTime? start
    })
async
{
    final DateTime? picked = await showDatePicker(

        context: context,
        initialDate: selectedDate ?? (start != null && start.isAfter(DateTime.now()) ? start : DateTime.now()),
        firstDate: start ?? DateTime(2015, 8),
        lastDate: DateTime(2112)
    );

    if (picked != null && picked != selectedDate) setState(picked);
}