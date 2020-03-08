import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/models/XYPoint.dart';
import 'dart:math' as math;
import 'package:p5/p5.dart';

List<XYPoint> routePoints;
ValueNotifier<int> notifier;

class CanvasScreen extends StatefulWidget {
  CanvasScreen(List<XYPoint> points, ValueNotifier<int> _notifier){
    routePoints = points;
    notifier = _notifier;
  }

  @override
  _CanvasScreenState createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: CustomPaint(size: new Size(300, 300), painter: Painter(notifier)),
    );
  }
}

class Painter extends CustomPainter {
  ValueNotifier<int> valueNotifier;
  Paint _paint;

  Painter(this.valueNotifier) : super(repaint: valueNotifier){
    _paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var r = new Random();
    for(int i = 0; i < 3; i++){
      canvas.drawLine(XYtoOffset(routePoints[i]), XYtoOffset(routePoints[i+1]), _paint);
    }
    Offset first = new Offset(r.nextDouble()*100 + 50, routePoints[0].y);
    Offset last = new Offset(routePoints[3].x, routePoints[3].y);
    canvas.drawLine(last, first, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  Offset XYtoOffset(XYPoint xy){
    return new Offset(xy.x, xy.y);
  }
}
