import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/canvas/canvasOptions.dart';

CanvasOptions _options;

class CanvasWidget extends StatefulWidget {
  CanvasWidget(CanvasOptions options) {
    _options = options;
  }

  @override
  _CanvasWidgetState createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: CustomPaint(size: new Size(300, 300), painter: Painter()),
    );
  }
}

class Painter extends CustomPainter {
  Paint _paint;
  Paint _paintHelperLine;

  Painter() : super(repaint: _options.repaintNotifier) {
    _paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;

    _paintHelperLine = Paint()
      ..color = Color.fromRGBO(40, 40, 40, 0.5)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < _options.points.length - 1; i++) {
      canvas.drawLine(xyPointToOffset(_options.points[i]),
          xyPointToOffset(_options.points[i + 1]), _paint);
    }
    canvas.drawLine(
        xyPointToOffset(_options.points[_options.points.length - 1]),
        xyPointToOffset(_options.points[0]),
        _paint);

    if (_options.helperLinesActivated) drawHelperLines(canvas);
  }

  void drawHelperLines(Canvas canvas) {
    double xStep = _options.screenWidth / (_options.xAxisClippingSteps + 1);
    double yStep = _options.screenHeight / (_options.yAxisClippingSteps + 1);
    for (int i = 1; i <= _options.xAxisClippingSteps; i++) {
      canvas.drawLine(Offset(xStep * i, 0),
          Offset(xStep * i, _options.screenHeight), _paintHelperLine);
    }
    for (int i = 1; i <= _options.yAxisClippingSteps; i++) {
      canvas.drawLine(Offset(0, yStep * i),
          Offset(_options.screenWidth, yStep * i), _paintHelperLine);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  Offset xyPointToOffset(XYPoint xy) {
    return new Offset(xy.x, xy.y);
  }
}
