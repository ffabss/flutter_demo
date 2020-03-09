import 'package:flutter/foundation.dart';

class DoubleRef{
  double value = 1;
  ValueNotifier<int> listenable = new ValueNotifier(0);
  DoubleRef(this.value);
}