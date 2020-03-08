import 'package:flutter/material.dart';
import 'package:flutter_demo/models/XYPoint.dart';

List<XYPoint> routePoints;
ValueNotifier<int> notifier;

class DragView extends StatefulWidget {
  DragView(List<XYPoint> points, ValueNotifier<int> _notifier) {
    routePoints = points;
    notifier = _notifier;
  }

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<DragView> {
  List<DraggableWidget> draggableWidgets = <DraggableWidget>[
    DraggableWidget(routePoints[0]),
    DraggableWidget(routePoints[1]),
    DraggableWidget(routePoints[2]),
    DraggableWidget(routePoints[3]),
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
  @override
  Widget build(BuildContext context) {
    return Icon(
      IconData(58731, fontFamily: 'MaterialIcons'),
      size: 36,
    );
  }
}

class DraggableWidget extends StatefulWidget {
  DraggableWidget(XYPoint point){
    this.point = point;
  }
  XYPoint point;

  @override
  _DragState createState() => _DragState(point);
}

class _DragState extends State<DraggableWidget> {
  _DragState(XYPoint point){
    this.point = point;
  }

  XYPoint point;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      child: Container(
        padding: EdgeInsets.only(top: point.y, left: point.x),
        child: DragItem(),
      ),
      feedback: Container(
        padding: EdgeInsets.only(top: point.y, left: point.x),
        child: DragItem(),
      ),
      childWhenDragging: Container(
        padding: EdgeInsets.only(top: point.y, left: point.x),
        child: DragItem(),
      ),
      onDragCompleted: () {},
      onDragEnd: (drag) {
        setState(() {
          point.y = point.y + drag.offset.dy < 0 ? 0 : point.y + drag.offset.dy;
          point.x = point.x + drag.offset.dx < 0 ? 0 : point.x + drag.offset.dx;
        });
        notifier.value += 1;
      },
    );
  }
}
