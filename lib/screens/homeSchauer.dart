import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/models/buttonRedborder.dart';
import 'package:flutter_demo/screens/routeScreen.dart';
import 'package:flutter_demo/screens/socketScreen.dart';
import 'package:flutter_demo/screens/wifiScreen.dart';
import 'package:flutter_icons/flutter_icons.dart';

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
                mainAxisAlignment: MainAxisAlignment.center,
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
              Container(
                height: 45,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Up Next",
                        textAlign: TextAlign.left,
                        textScaleFactor: 1.8,
                        style: TextStyle(color: Colors.grey),
                      )),
                  Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(25.0),
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          border: new Border.all(color: Colors.grey)),
                      child: Text(
                        "10:30 - Stall rechts",
                        textAlign: TextAlign.left,
                        textScaleFactor: 1.8,
                        style: TextStyle(color: Colors.grey),
                      ))
                ],
              ),
              Flexible(
                  child: GridView.count(
                crossAxisCount: 3,
                reverse: false,
                children: <Widget>[
                  ButtonRedBorder(
                    iconToUse: FontAwesome5Solid.pencil_ruler,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                  ),
                  ButtonRedBorder(
                    iconToUse: FontAwesome5Solid.pencil_ruler,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                  ),
                  ButtonRedBorder(
                    iconToUse: FontAwesome5Solid.pencil_ruler,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                  ),
                  ButtonRedBorder(
                    iconToUse: FontAwesome5Solid.wifi,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WifiRoute()),
                      );
                    },
                  ),
                  ButtonRedBorder(
                    iconToUse: FontAwesome5Solid.wifi,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WifiRoute()),
                      );
                    },
                  ),
                  ButtonRedBorder(
                    iconToUse: FontAwesome5Solid.wifi,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WifiRoute()),
                      );
                    },
                  ),
                  ButtonRedBorder(
                    iconToUse: FontAwesome5Solid.terminal,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SocketScreen()),
                      );
                    },
                  ),
                  ButtonRedBorder(
                    iconToUse: FontAwesome5Solid.terminal,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SocketScreen()),
                      );
                    },
                  ),
                  ButtonRedBorder(
                    iconToUse: FontAwesome5Solid.terminal,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SocketScreen()),
                      );
                    },
                  ),
                ],
              )),
            ])));
  }
}
