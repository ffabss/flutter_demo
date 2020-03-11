import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/models/XYPoint.dart';
import 'package:flutter_demo/models/dataTypeReferences.dart';
import 'package:flutter_demo/models/slider.dart';
import 'package:flutter_icons/flutter_icons.dart';

final ValueNotifier<int> _repaintNotifier = ValueNotifier<int>(0);
final double dragItemSize = 18;

int xAxisClippingSteps = 10;
int yAxisClippingSteps = 10;

final DoubleRef sliderValY = new DoubleRef(10);
final DoubleRef sliderValX = new DoubleRef(10);

double width = 1;
double height = 1;

bool helperLinesActivated = true;
bool clippingSystemActivated = true;

double _scale = 1;

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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool areSettingsVisible = false;

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
                GestureDetector(
                  onScaleUpdate: _onScaleUpdate,
                  child: Stack(
                    children: <Widget>[
                      CanvasScreen(),
                      DragView(),
                    ],
                  ),
                ),
                Visibility(
                  visible: areSettingsVisible,
                  child: Container(
                    color: Color.fromRGBO(250, 250, 250, 0.95),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 60,
                        ),
                        Text('X Axis'),
                        CustomSlider(sliderValX),
                        Text('Y Axis'),
                        CustomSlider(sliderValY),
                        Container(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton.extended(
                              onPressed: () {
                                setState(() {
                                  helperLinesActivated = !helperLinesActivated;
                                  _repaintNotifier.value += 1;
                                });
                              },
                              label: Text(helperLinesActivated
                                  ? 'Hilfslinien ausschalten'
                                  : 'Hilfslinien einschalten'),
                              icon: Icon(Icons.line_weight),
                              foregroundColor: Colors.white,
                              backgroundColor: helperLinesActivated ? Colors.red : Color.fromRGBO(100, 100, 100, 1),
                            ),
                          ],
                        ),
                        Container(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton.extended(
                              onPressed: () {
                                setState(() {
                                  clippingSystemActivated =
                                      !clippingSystemActivated;
                                  _repaintNotifier.value += 1;
                                });
                              },
                              label: Text(clippingSystemActivated
                                  ? 'Clipping-System ausschalten'
                                  : 'Clipping-System einschalten'),
                              icon: Icon(FontAwesome.magnet),
                              foregroundColor: Colors.white,
                              backgroundColor: clippingSystemActivated ? Colors.red : Color.fromRGBO(100, 100, 100, 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            areSettingsVisible = !areSettingsVisible;
          });
        },
        label: Text('Settings'),
        icon: Icon(Icons.settings),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
      ),
    );
  }

  void _onScaleUpdate(ScaleUpdateDetails event) {
    print('bro we are scaling');
    return;
    _scale = event.scale;
    _repaintNotifier.value += 1;
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
  Paint _paintHelperLine;

  Painter() : super(repaint: _repaintNotifier) {
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
    canvas.scale(_scale);
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(XYtoOffset(points[i]), XYtoOffset(points[i + 1]), _paint);
    }
    canvas.drawLine(XYtoOffset(points[3]), XYtoOffset(points[0]), _paint);

    if (helperLinesActivated) {
      for (int i = 1; i <= xAxisClippingSteps; i++) {
        double xStep = width / (xAxisClippingSteps + 1);
        canvas.drawLine(
            Offset(xStep * i * _scale, 0), Offset(xStep * i * _scale, height * _scale), _paintHelperLine);
      }
      for (int i = 1; i <= yAxisClippingSteps; i++) {
        double yStep = height / (yAxisClippingSteps + 1);
        canvas.drawLine(
            Offset(0, yStep * i * _scale), Offset(width * _scale, yStep * i * _scale), _paintHelperLine);
      }
    }
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
  bool isSelected;

  DragItem(this.opacity, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.fiber_manual_record,
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
  bool isSelected = false;

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
            child: DragItem(1, isSelected),
          ),
          feedback: Container(
            child: DragItem(0.4, isSelected),
          ),
          childWhenDragging: Container(
            child: DragItem(1, isSelected),
          ),
        ),
      ),
    );
  }

  Offset position = Offset(0.0, 0.0);
  Offset dragPosition = Offset(0, 0);

  @override
  void initState() {
    super.initState();
    position = widget.initPos;
    sliderValY.listenable.addListener(() {
      yAxisClippingSteps = sliderValY.value.round();
    });
    sliderValX.listenable.addListener(() {
      xAxisClippingSteps = sliderValX.value.round();
    });
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
      isSelected = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      dragPosition += event.delta;
      position = validatePos(dragPosition);
      point.x = position.dx;
      point.y = position.dy;
      _repaintNotifier.value += 1;
    });
  }

  Offset validatePos(Offset position) {
    if (clippingSystemActivated) {
      double xStepWidth = width / (xAxisClippingSteps + 1);
      double yStepHeight = height / (yAxisClippingSteps + 1);
      double xStep = position.dx / xStepWidth;
      double yStep = position.dy / yStepHeight;

      double xHigher = xStep.ceilToDouble();
      double xLower = xStep.floorToDouble();
      double yHigher = yStep.ceilToDouble();
      double yLower = yStep.floorToDouble();

      if (xStep - xLower < xHigher - xStep) {
        if (yStep - yLower < yHigher - yStep) {
          return Offset(xLower * xStepWidth, yLower * yStepHeight);
        } else {
          return Offset(xLower * xStepWidth, yHigher * yStepHeight);
        }
      } else {
        if (yStep - yLower < yHigher - yStep) {
          return Offset(xHigher * xStepWidth, yLower * yStepHeight);
        } else {
          return Offset(xHigher * xStepWidth, yHigher * yStepHeight);
        }
      }
    } else {
      return position;
    }
  }
}
