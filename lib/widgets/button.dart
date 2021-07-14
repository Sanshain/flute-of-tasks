import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class StyledButton extends StatelessWidget{

    const StyledButton(this.text, {Key? key, this.padding, this.onPress}) : super(
        key: key
    );

    final EdgeInsetsGeometry? padding;
    final String text;
    final Future<void> Function()? onPress;

    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: padding ?? const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.black38,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                    )
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(text, style: const TextStyle(fontSize: 16))
                    ),
                ),
                onPressed: () async {
                    await onPress?.call();
                    Navigator.of(context).pop();
                }
            ),
        );
    }

}