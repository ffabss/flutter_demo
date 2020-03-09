import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/screens/homeSchauer.dart';
import 'package:flutter_demo/screens/socketScreen.dart';
import 'package:flutter_demo/screens/wifiScreen.dart';
import 'package:flutter_demo/screens/routeScreen.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Color _inactiveColor = Colors.grey;
  Color _activeColor = Colors.lightGreen;

  List<Widget> _widgetOptions = <Widget>[
    HomeSchauer(),
    HomePage(),
    WifiRoute(),
    SocketScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Feather.home,
              color: _inactiveColor,
            ),
            title: Text('HOME'),
            activeIcon: Icon(
              Feather.home,
              color: _activeColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesome.pencil,
              color: _inactiveColor,
            ),
            title: Text('HOME'),
            activeIcon: Icon(
              FontAwesome.pencil,
              color: _activeColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesome.wifi,
              color: _inactiveColor,
            ),
            title: Text('CALENDAR'),
            activeIcon: Icon(
              FontAwesome.wifi,
              color: _activeColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesome.connectdevelop,
              color: _inactiveColor,
              size: 36,
            ),
            title: Text('PROFILE'),
            activeIcon: Icon(
              FontAwesome.connectdevelop,
              color: _activeColor,
              size: 36,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }

}