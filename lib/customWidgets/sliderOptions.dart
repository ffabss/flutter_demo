import 'package:flutter/material.dart';

class SliderOptions{
  double value = 1;
  ValueNotifier<int> sliderValChanged = new ValueNotifier(1);

  SliderOptions(this.value); //Constructor
}