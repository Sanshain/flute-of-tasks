import 'package:flutter/material.dart';

typedef OnChangeEvent = Function(String text);

//Widget inputField({String hint = '', maxLines = 1, minLines = 1, autofocus = false, value = '', TextEditingController? controller}){

Widget inputField({String hint = '', maxLines = 1, minLines = 1, autofocus = false, value = '', OnChangeEvent? onChanged}){
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
//            controller: controller,
            initialValue: value,
            autofocus: autofocus,
            maxLines: maxLines,
            minLines: minLines,
            style: const TextStyle(fontSize: 22, color: Colors.black54),
            onChanged: (String text){
                onChanged?.call(text);
            },
            decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black38, width: 2.0),
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                    )
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                hintStyle: const TextStyle(fontSize: 20.0, color: Colors.black26),
                hintText: hint
            ),
        ),
    );
}