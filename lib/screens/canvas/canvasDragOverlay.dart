import 'package:flutter/material.dart';
import 'package:flutter_demo/customWidgets/sliderOptions.dart';
import 'package:flutter_demo/screens/canvas/canvasOptions.dart';

CanvasOptions _options;
SliderOptions _sliderValX;
SliderOptions _sliderValY;

class DragOverlay extends StatefulWidget {
  DragOverlay(CanvasOptions options, SliderOptions sliderOptionsX,
      SliderOptions sliderOptionsY) {
    _options = options;
    _sliderValX = sliderOptionsX;
    _sliderValY = sliderOptionsY;
  }

  @override
  _DragOverlayState createState() => _DragOverlayState();
}

class _DragOverlayState extends State<DragOverlay> {
  List<DraggableWidget> draggableWidgets = List.generate(
      _options.points.length, (index) =>
  new DraggableWidget(
      _options.points[index]));

  //List<DraggableWidget> draggableWidgets = <DraggableWidget>[
  //  DraggableWidget(points[0]),
  //  DraggableWidget(points[1]),
  //  DraggableWidget(points[2]),
  //  DraggableWidget(points[3]),
  //];

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
  final double opacity;

  DragItem(this.opacity);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.fiber_manual_record,
      size: _options.dragItemSize,
      color: Colors.black.withOpacity(opacity),
    );
  }
}

class DraggableWidget extends StatefulWidget {
  final XYPoint point;
  Offset initPos;

  DraggableWidget(this.point) {
    initPos = new Offset(point.x, point.y);
  }

  @override
  _DragState createState() => _DragState(point);
}

class _DragState extends State<DraggableWidget> {
  XYPoint point;
  Offset position = Offset(0.0, 0.0);
  Offset dragPosition = Offset(0, 0);

  _DragState(this.point);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - _options.dragItemSize / 2,
      top: position.dy - _options.dragItemSize / 2,
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

  @override
  void initState() {
    super.initState();
    position = widget.initPos;
    _sliderValY.sliderValChanged.addListener(() {
      _options.yAxisClippingSteps = _sliderValY.value.round();
    });
    _sliderValX.sliderValChanged.addListener(() {
      _options.xAxisClippingSteps = _sliderValX.value.round();
    });
  }

  void _onPointerMove(PointerMoveEvent event) {
    setState(() {
      dragPosition += event.delta;
      position = validatePos(dragPosition);
      point.x = position.dx;
      point.y = position.dy;
      _options.repaintNotifier.value += 1;
    });
  }

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      dragPosition = position;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      dragPosition += event.delta;
      position = validatePos(dragPosition);
      point.x = position.dx;
      point.y = position.dy;
      _options.repaintNotifier.value += 1;
    });
  }

  Offset validatePos(Offset position) {
    if (_options.clippingSystemActivated) {
      double xStepWidth = _options.getXStepWidth();
      double yStepHeight = _options.getYStepHeight();
      double xStep = position.dx / xStepWidth;
      double yStep = position.dy / yStepHeight;

      double xHigher = xStep.ceilToDouble();
      double xLower = xStep.floorToDouble();
      double yHigher = yStep.ceilToDouble();
      double yLower = yStep.floorToDouble();

      var possiblePoints = <Offset>[
        //xLower, yLower are nearest
        Offset(xLower * xStepWidth, yLower * yStepHeight),
        //xLower, yHigher are nearest
        Offset(xLower * xStepWidth, yHigher * yStepHeight),
        //xHigher, yLower are nearest
        Offset(xHigher * xStepWidth, yLower * yStepHeight),
        //xHigher, yHigher are nearest
        Offset(xHigher * xStepWidth, yHigher * yStepHeight),
      ];

      possiblePoints.sort((a, b) =>
          (position - a).distance.compareTo((position - b).distance));
      return possiblePoints.first;
    } else {
      return position;
    }
  }
}
