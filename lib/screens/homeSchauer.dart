import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/models/buttonRedborder.dart';

class HomeSchauer extends StatefulWidget {
  _HomeSchauerState createState() => _HomeSchauerState();
}

class _HomeSchauerState extends State<HomeSchauer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true, // this is all you need
          title: Text("Schauer"),
          backgroundColor: Colors.red,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              Material(
                  child: Text(
                "Hallo, Alex",
                textAlign: TextAlign.center,
                textScaleFactor: 5,
                style: TextStyle(color: Colors.black),
              )),
              Material(
                  child: Text(
                "Enro 6",
                textAlign: TextAlign.center,
                textScaleFactor: 2,
                style: TextStyle(color: Colors.grey),
              )),
              Flexible(
                  child: GridView.count(
                crossAxisCount: 3,
                children: <Widget>[
                  ButtonRedBorder(
                    iconToUse: Icons.timer,
                    onPressed: () {
                      print("Tapped Me");
                    },
                  ),
                  ButtonRedBorder(
                    iconToUse: Icons.timer,
                    onPressed: () {
                      print("Tapped Me");
                    },
                  ),
                  ButtonRedBorder(
                    iconToUse: Icons.timer,
                    onPressed: () {
                      print("Tapped Me");
                    },
                  ),
                  ButtonRedBorder(
                    iconToUse: Icons.timer,
                    onPressed: () {
                      print("Tapped Me");
                    },
                  ),
                  ButtonRedBorder(
                    iconToUse: Icons.timer,
                    onPressed: () {
                      print("Tapped Me");
                    },
                  ),
                  ButtonRedBorder(
                    iconToUse: Icons.timer,
                    onPressed: () {
                      print("Tapped Me");
                    },
                  ),
                ],
              )),
            ])));
  }
}
