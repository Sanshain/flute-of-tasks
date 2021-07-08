//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget instantTransition (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    var begin = const Offset(0.0, 1.0);
    var end = Offset.zero;
    var tween = Tween(begin: begin, end: end);
    var offsetAnimation = animation.drive(tween);
    return child;
}