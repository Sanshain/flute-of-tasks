import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


enum TimeUnits {
    hour,
    day
}

class SliderOptions{
    int? max;

    SliderOptions({this.max});
}


class SliderWidget extends StatefulWidget {

    const SliderWidget({Key? key, this.value = 0, this.units = TimeUnits.hour, this.options, this.onChange}) : super(key: key);

    final SliderOptions? options;
    final TimeUnits units;
    final int value;
    final void Function(int)? onChange;

    @override State<SliderWidget> createState() => SliderState();
}

class SliderState extends State<SliderWidget> {

    int value = 0;

    @override void initState() { super.initState();

        value = widget.value;
    }

    @override Widget build(BuildContext context) {
        return SizedBox(
            height: 100,
          child: Column(
              children: [
                  const Center(
                      child: Text('Estimate task execution time', style: TextStyle(color: Colors.black38)),
                  ),
                  Slider(
                      activeColor: Colors.black26,
                      inactiveColor: Colors.black12,
                      max: widget.options?.max?.toDouble() ?? (widget.units == TimeUnits.hour ? 24 : 30),
                      label: ("$value ${widget.units.toString().split('.').last}" + (value != 1 ? 's' : '')),
                      value: value.toDouble(),
                      onChanged: (v) => setState(() {
                          value = v.toInt();
                          widget.onChange?.call(value);
                      })
                  ),
                  Text("$value ${widget.units.toString().split('.').last}" + (value != 1 ? 's' : ''))
              ]
          ),
        );
    }
}


Future<int?> sliderDialog(BuildContext context, {value = 0, units = TimeUnits.hour, SliderOptions? options, title = ''}) async {

    int _value = value;

    return showDialog(
        context: context,
        barrierDismissible: false,

        builder: (BuildContext context) {
            return AlertDialog(
                title: Center(child: Text(title)),
                content: SliderWidget(value: value, units: units, options: options, onChange: (v) => _value = v,),
                actions: <Widget>[
                    // ignore: deprecated_member_use
                    Center(
                        child: ElevatedButton(
                            child: const Text('Ok'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black38, onPrimary: Colors.white, shadowColor: Colors.transparent
                            ),
                            onPressed: () => Navigator.of(context).pop(_value),
                        ),
                    ),
                ],
            );
        },
    );
}