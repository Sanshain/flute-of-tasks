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


Future<bool>? showConfirmationDialog(BuildContext context, String action, {String title = 'Подтверждение'}) {
// show the dialog

    showDialog<bool>(
        context: context,
//        barrierDismissible: true,
//        barrierColor: Colors.lightBlueAccent,
        builder: (BuildContext context) {
            return AlertDialog(
                title: Text(title),
                content: SizedBox(
                    height: 50,
                    child: Text(
                        action,
//                        style: const TextStyle(fontSize: 22, color: Colors.blue),
                    ),
                ),
                actions: [
                    TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                            Navigator.pop(context, true);
                        },
                    ),
                    TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                            Navigator.pop(context, false);
                        },
                    )
                ],
            );
        },
    );
}



Future<void> selectDate(BuildContext context, DateTime? selectedDate, {required Function(DateTime) setState}) async {

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)
    );

    if (picked != null && picked != selectedDate) setState(picked);

}