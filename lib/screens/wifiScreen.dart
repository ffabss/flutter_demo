import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wifi_configuration/wifi_configuration.dart';
import 'package:location/location.dart';

class WifiScreen extends StatefulWidget {
  _WifiScreenState createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  Location location = new Location();
  List<String> items = new List();

  var _mainColor = Colors.red;

  void updateList(List<dynamic> items) {
    setState(() {
      this.items = items.map((x) => x.toString()).toSet().toList();
    });
  }

  void connectTo(int index) async {
    final myController = TextEditingController();

    Alert alert = Alert(
        context: context,
        title: "Connect to ${items[index].toString()}",
        content: Column(
          children: <Widget>[
            TextField(
              obscureText: true,
              controller: myController,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Password',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Connect",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]);
    await alert.show();
    String pass = myController.value.toString();
    WifiConfiguration.connectToWifi(
        items[index], pass, "com.example.flutter_demo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () => connectTo(index),
              child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.grey[((index % 5) + 3) * 100],
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(10.0))),
                  height: 50,
                  //  child: Center(child: Text('${items[index]}')),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: new Icon(Icons.wifi),
                        onPressed: () => connectTo(index),
                      ),
                      Text('${items[index]}'),
                    ],
                  )));
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!await verifyLocationStatus()) {
            return;
          }
          setState(() {
            WifiConfiguration.getWifiList().then((value) => updateList(value));
          });
        },
        backgroundColor: _mainColor,
        child: Icon(Icons.network_wifi),
      ),
    );
  }

  Future<bool> verifyLocationStatus() async {
    if (await location.hasPermission() == PermissionStatus.DENIED) {
      if (await location.requestPermission() != PermissionStatus.GRANTED) {
        return false;
      }
    }
    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return false;
      }
    }
    return true;
  }
}
