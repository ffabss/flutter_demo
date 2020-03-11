import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CanvasOptions {
  final double dragItemSize = 18;

  double screenWidth = 1;
  double screenHeight = 1;

  int xAxisClippingSteps = 10;
  int yAxisClippingSteps = 10;

  bool helperLinesActivated = true;
  bool clippingSystemActivated = true;

  ValueNotifier<int> repaintNotifier = new ValueNotifier(1);

  //Demo Points for Testing
  var points = <XYPoint>[
    new XYPoint(100, 100),
    new XYPoint(200, 100),
    new XYPoint(200, 200),
    new XYPoint(100, 200),
  ];

  double getXStepWidth() => screenWidth / (xAxisClippingSteps + 1);
  double getYStepHeight() => screenHeight / (yAxisClippingSteps + 1);
}

class XYPoint{
  double x;
  double y;

  XYPoint(this.x, this.y); //Constructor
}