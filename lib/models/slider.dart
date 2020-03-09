import 'package:flutter/material.dart';
import 'package:flutter_demo/models/dataTypeReferences.dart';



class CustomSlider extends StatefulWidget {
  DoubleRef reference;
  CustomSlider(this.reference);

  @override
  _SliderState createState() => _SliderState(reference);
}

class _SliderState extends State<CustomSlider> {
  DoubleRef reference;
  _SliderState(this.reference);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.red[700],
            inactiveTrackColor: Colors.red[100],
            trackShape: RoundedRectSliderTrackShape(),
            trackHeight: 4.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
            thumbColor: Colors.redAccent,
            overlayColor: Colors.red.withAlpha(32),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            tickMarkShape: RoundSliderTickMarkShape(),
            activeTickMarkColor: Colors.red[700],
            inactiveTickMarkColor: Colors.red[100],
            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: Colors.redAccent,
            valueIndicatorTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          child: Slider(
            value: reference.value,
            min: 1,
            max: 100,
            divisions: 99,
            label: reference.value.toString(),
            onChanged: (value) {
              setState(
                () {
                  reference.value = value;
                },
              );
              reference.listenable.value += 1;
            },
          ),
        ),
    );
  }
}
