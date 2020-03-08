import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/models/XYPoint.dart';

final ValueNotifier<int> _repaintNotifier = ValueNotifier<int>(0);

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

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
        children: <Widget>[
          CanvasScreen(),
          Container(
            child: DragView(),
          ),
        ],
      )),
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
    //Offset first = new Offset(r.nextDouble() * 100 + 50, points[0].y);
    //Offset last = new Offset(points[3].x, points[3].y);
    //canvas.drawLine(last, first, _paint);
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
      size: 36,
      color: Colors.black.withOpacity(opacity),
    );
  }
}

class DraggableWidget extends StatefulWidget {
  Offset initPos;

  DraggableWidget(XYPoint point) {
    this.point = point;
    initPos = Offset(point.x, point.y);
  }

  XYPoint point;

  @override
  _DragState createState() => _DragState(point);
}

class _DragState extends State<DraggableWidget> {
  _DragState(XYPoint point) {
    this.point = point;
  }

  XYPoint point;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: _onPointerMove,
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: Draggable(
        child: Container(
          padding: EdgeInsets.only(top: point.y - 18, left: point.x - 18),
          child: DragItem(1),
        ),
        feedback: Container(
          padding: EdgeInsets.only(top: point.y - 18, left: point.x - 18),
          child: DragItem(0.4),
        ),
        childWhenDragging: Container(
          padding: EdgeInsets.only(top: point.y - 18, left: point.x - 18),
          child: DragItem(1),
        ),
        onDragCompleted: () {},
        onDragEnd: (drag) {
          setState(() {
            point.y = point.y + drag.offset.dy < 0
                ? 0
                : point.y + drag.offset.dy - 18;
            point.x = point.x + drag.offset.dx < 0
                ? 0
                : point.x + drag.offset.dx - 18;
          });
          _repaintNotifier.value += 1;
        },
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
  }

  List<Offset> _initPoints() {
    List<Offset> tmp = List.generate(10, (index) {
      return Offset((index * 10).toDouble(), (index * 100).toDouble());
    });
    tmp.addAll(List.generate(10, (index) {
      return Offset((index * 10 + 100).toDouble(), (index * 100).toDouble());
    }));
    tmp.addAll(List.generate(10, (index) {
      return Offset((index * 10 + 200).toDouble(), (index * 100).toDouble());
    }));

    return tmp;
  }

  void _onPointerMove(PointerMoveEvent event) {
    setState(() {
      dragPosition += event.delta;
      position = validatePos(dragPosition);
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
