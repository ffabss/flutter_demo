import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/models/XYPoint.dart';
import 'package:flutter_demo/models/dataTypeReferences.dart';
import 'package:flutter_demo/models/slider.dart';

final ValueNotifier<int> _repaintNotifier = ValueNotifier<int>(0);
final double dragItemSize = 36;

int xAxisClippingSteps = 10;
int yAxisClippingSteps = 10;

final DoubleRef sliderValY = new DoubleRef(50);
final DoubleRef sliderValX = new DoubleRef(50);

double width = 1;
double height = 1;

var points = <XYPoint>[
  new XYPoint(100, 100),
  new XYPoint(200, 100),
  new XYPoint(200, 200),
  new XYPoint(100, 200),
];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    print(width);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                CanvasScreen(),
                DragView(),
              ],
            ),
          ),
          Text('X Axis'),
          CustomSlider(sliderValX),
          Text('Y Axis'),
          CustomSlider(sliderValY),
        ],
      ),
    );
  }
}

// //
// //
// //
// // PAINTING IS HERE
// //
// //
// //

class CanvasScreen extends StatefulWidget {
  @override
  _CanvasScreenState createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: CustomPaint(size: new Size(300, 300), painter: Painter()),
    );
  }
}

class Painter extends CustomPainter {
  Paint _paint;

  Painter() : super(repaint: _repaintNotifier) {
    _paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var r = new Random();
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(XYtoOffset(points[i]), XYtoOffset(points[i + 1]), _paint);
    }
    canvas.drawLine(XYtoOffset(points[3]), XYtoOffset(points[0]), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  Offset XYtoOffset(XYPoint xy) {
    return new Offset(xy.x, xy.y);
  }
}

// //
// //
// //
// // DRAGGING IS HERE
// //
// //
// //

class DragView extends StatefulWidget {
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<DragView> {
  //List<DraggableWidget> draggableWidgets = List.generate(points.length, (index) => new DraggableWidget(points[index]));

  List<DraggableWidget> draggableWidgets = <DraggableWidget>[
    DraggableWidget(points[0]),
    DraggableWidget(points[1]),
    DraggableWidget(points[2]),
    DraggableWidget(points[3]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: draggableWidgets,
      ),
    );
  }
}

class DragItem extends StatelessWidget {
  double opacity;

  DragItem(this.opacity);

  @override
  Widget build(BuildContext context) {
    return Icon(
      IconData(58731, fontFamily: 'MaterialIcons'),
      size: dragItemSize,
      color: Colors.black.withOpacity(opacity),
    );
  }
}

class DraggableWidget extends StatefulWidget {
  Offset initPos;
  XYPoint point;

  DraggableWidget(XYPoint point) {
    this.point = point;
    initPos = new Offset(point.x, point.y);
  }

  @override
  _DragState createState() => _DragState(point);
}

class _DragState extends State<DraggableWidget> {
  XYPoint point;

  _DragState(XYPoint point) {
    this.point = point;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - dragItemSize / 2,
      top: position.dy - dragItemSize / 2,
      child: Listener(
        onPointerMove: _onPointerMove,
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        child: Draggable(
          child: Container(
            child: DragItem(1),
          ),
          feedback: Container(
            child: DragItem(0.4),
          ),
          childWhenDragging: Container(
            child: DragItem(1),
          ),
        ),
      ),
    );
  }

  Offset position = Offset(0.0, 0.0);
  Offset dragPosition = Offset(0, 0);
  List<Offset> validPoints = new List();

  @override
  void initState() {
    super.initState();
    position = widget.initPos;
    validPoints = _initPoints();
    sliderValY.listenable.addListener((){
      yAxisClippingSteps = sliderValY.value.round();
      validPoints = _initPoints();
    });
    sliderValX.listenable.addListener((){
      xAxisClippingSteps = sliderValX.value.round();
      validPoints = _initPoints();
    });
  }

  List<Offset> _initPoints() {
    double xStep = width / (xAxisClippingSteps + 1);
    double yStep = height / (yAxisClippingSteps + 2);

    print(xStep);

    List<Offset> temp = new List<Offset>();
    new List<int>.generate(xAxisClippingSteps, (i) => i).forEach((i) {
      temp.addAll(List.generate(
          yAxisClippingSteps,
          (index) => Offset(
              ((i + 1) * xStep).toDouble(), ((index + 1) * yStep).toDouble())));
    });
    return temp;
  }

  void _onPointerMove(PointerMoveEvent event) {
    setState(() {
      dragPosition += event.delta;
      position = validatePos(dragPosition);
      point.x = position.dx;
      point.y = position.dy;
      _repaintNotifier.value += 1;
    });
  }

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      dragPosition = position;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    dragPosition += event.delta;
    position = validatePos(dragPosition);
  }

  int _totalDistance(Offset a, Offset b) {
    Offset tmp = (a.dx + a.dy) > (b.dx + b.dy) ? a - b : b - a;
    return (tmp.dx.abs() + tmp.dy.abs()).round();
  }

  Offset validatePos(Offset position) {
    validPoints.sort(
        (a, b) => _totalDistance(a, position) - _totalDistance(b, position));
    return validPoints.first;
  }
}
