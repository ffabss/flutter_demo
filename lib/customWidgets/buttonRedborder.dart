import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ButtonRedBorder extends StatelessWidget {
  ButtonRedBorder({@required this.onPressed, @required this.iconToUse});

  final GestureTapCallback onPressed;
  final IconData iconToUse;

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.all(5),
        child: OutlineButton(
          splashColor: Colors.redAccent,
          focusColor: Colors.red,
          borderSide: BorderSide(color: Colors.red),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(iconToUse),
            ],
          ),
          onPressed: onPressed,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
        ));
  }
}
