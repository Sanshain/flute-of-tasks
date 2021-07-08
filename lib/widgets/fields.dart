import 'package:flutter/material.dart';

Widget inputField({String hint = '', maxLines = 1, minLines = 1}){
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
            maxLines: maxLines,
            minLines: minLines,
            style: const TextStyle(fontSize: 22, color: Colors.blue),
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                    )
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                hintStyle: const TextStyle(fontSize: 20.0, color: Colors.black26),
                hintText: hint
            ),
        ),
    );
}