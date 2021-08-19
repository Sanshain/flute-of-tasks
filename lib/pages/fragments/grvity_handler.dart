import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IncreasingFragment extends StatefulWidget {

    const IncreasingFragment({Key? key, this.value = 0, this.onChange}) : super(key: key);

    final int value;
    final void Function(int)? onChange;

    @override State<IncreasingFragment> createState() => IncreasingState();
}

class IncreasingState extends State<IncreasingFragment> {

    int value = 0;

    @override void initState() {
        super.initState();
        value = widget.value;
    }

    @override Widget build(BuildContext context) {
        return Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(30, 30),
                        shape: const CircleBorder(),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        shadowColor: Colors.transparent,
                        primary: Colors.black12
                    ),
                    onPressed: () {
                        setState(() => value++);
                        widget.onChange?.call(value);
                    },
                    child: const Icon(Icons.plus_one),
                ),
                Text(value.toString()),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(30, 30),
                        shape: const CircleBorder(),
                        shadowColor: Colors.transparent,
                        primary: Colors.black12
                    ),
                    onPressed: () {
                        if (value > 0) {
                            setState(() => value--);
                            widget.onChange?.call(value);
                        }
                    },
                    child: const Icon(Icons.exposure_minus_1),
                )
            ],
        );
    }
}


Future<int?> increasingDialog(BuildContext context, {value = 0, title = 'Title'}) async {
    return showDialog(
        context: context,
        barrierDismissible: false, // dialog is dismissible with a tap on the barrier

        builder: (BuildContext context) {
            return AlertDialog(
                title: Center(child: Text(title)),
                content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        SizedBox(
                            height: 120,
                            child: IncreasingFragment(
                                value: value,
                                onChange: (_value) => value = _value,
                            ),
                        )
                    ],
                ),
                actions: <Widget>[
                    // ignore: deprecated_member_use
                    Center(
                        child: FlatButton(
                            child: const Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(value),
                        ),
                    ),
                ],
            );
        },
    );
}































class IncreasingDialog extends StatefulWidget {

    const IncreasingDialog({Key? key, this.value = 0, this.title = ""}) : super(key: key);

    final int value;
    final String title;

    @override State<IncreasingDialog> createState() => _DialogState();
}

class _DialogState extends State<IncreasingDialog> {

    int value = 0;

    @override initState() {
        super.initState();
        value = widget.value;
    }

    @override Widget build(BuildContext context) {
        return AlertDialog(
            title: Text(widget.title),
            content: Row(
                children: <Widget>[
                    Center(
                        child: IncreasingFragment(
                            value: widget.value,
                            onChange: (_value) =>
                                setState(() {
                                    value = _value;
                                }),
                        ),
                    )
                ]
            ),
            actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                    child: const Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(value),
                ),
            ],
        );
    }

}