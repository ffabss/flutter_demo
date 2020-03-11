import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_demo/customWidgets/customSlider.dart';
import 'package:flutter_demo/customWidgets/sliderOptions.dart';
import 'package:flutter_demo/screens/canvas/canvas.dart';
import 'package:flutter_demo/screens/canvas/canvasDragOverlay.dart';
import 'package:flutter_demo/screens/canvas/canvasOptions.dart';
import 'package:flutter_icons/flutter_icons.dart';

final SliderOptions _sliderValY = new SliderOptions(10);
final SliderOptions _sliderValX = new SliderOptions(10);
final CanvasOptions _canvasOptions = new CanvasOptions();

class RouteCanvas extends StatefulWidget {
  @override
  _RouteCanvasState createState() => _RouteCanvasState();
}

class _RouteCanvasState extends State<RouteCanvas>
    with TickerProviderStateMixin {
  bool areSettingsVisible = false;

  @override
  Widget build(BuildContext context) {
    _canvasOptions.screenWidth = MediaQuery.of(context).size.width;
    _canvasOptions.screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  child: Stack(
                    children: <Widget>[
                      CanvasWidget(_canvasOptions),
                      DragOverlay(_canvasOptions, _sliderValX, _sliderValY),
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
                        CustomSlider(_sliderValX),
                        Text('Y Axis'),
                        CustomSlider(_sliderValY),
                        Container(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton.extended(
                              onPressed: () {
                                setState(() {
                                  _canvasOptions.helperLinesActivated =
                                      !_canvasOptions.helperLinesActivated;
                                  _canvasOptions.repaintNotifier.value += 1;
                                });
                              },
                              label: Text(_canvasOptions.helperLinesActivated
                                  ? 'Hilfslinien ausschalten'
                                  : 'Hilfslinien einschalten'),
                              icon: Icon(Icons.line_weight),
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  _canvasOptions.helperLinesActivated
                                      ? Colors.red
                                      : Color.fromRGBO(100, 100, 100, 1),
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
                                  _canvasOptions.clippingSystemActivated =
                                      !_canvasOptions.clippingSystemActivated;
                                  _canvasOptions.repaintNotifier.value += 1;
                                });
                              },
                              label: Text(_canvasOptions.clippingSystemActivated
                                  ? 'Clipping-System ausschalten'
                                  : 'Clipping-System einschalten'),
                              icon: Icon(FontAwesome.magnet),
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  _canvasOptions.clippingSystemActivated
                                      ? Colors.red
                                      : Color.fromRGBO(100, 100, 100, 1),
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
}
