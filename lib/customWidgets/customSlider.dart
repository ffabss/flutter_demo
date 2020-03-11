import 'package:flutter/material.dart';
import 'package:flutter_demo/customWidgets/sliderOptions.dart';

class CustomSlider extends StatefulWidget {
  final SliderOptions _sliderOptions;

  CustomSlider(this._sliderOptions);

  @override
  _SliderState createState() => _SliderState(_sliderOptions);
}

class _SliderState extends State<CustomSlider> {
  SliderOptions _sliderOptions;

  _SliderState(this._sliderOptions);

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
          value: _sliderOptions.value,
          min: 1,
          max: 100,
          divisions: 99,
          label: _sliderOptions.value.toString(),
          onChanged: (value) {
            setState(
              () {
                _sliderOptions.value = value;
              },
            );
            _sliderOptions.sliderValChanged.value += 1;
          },
        ),
      ),
    );
  }
}
