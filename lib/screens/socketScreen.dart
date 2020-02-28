import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SocketScreen extends StatefulWidget {
  _SocketScreenState createState() => _SocketScreenState();
}

class Message {
  Message(this.sender, this.text);

  final String sender;
  final String text;

  @override
  String toString() {
    return "$sender:$text";
  }
}

class _SocketScreenState extends State<SocketScreen> {
  final List<Message> messages =
      new List.of([new Message("You", "seas"), new Message("NoYou", "seas")]);
  final myController = TextEditingController();
  final ScrollController _scrollController = new ScrollController();

  Socket socket;

  Future<void> connect() async {
    final _ipController = TextEditingController();
    final _portController = TextEditingController();

    Alert alert = Alert(
        context: context,
        title: "Connect to a socket",
        content: Column(
          children: <Widget>[
            TextField(
              obscureText: false,
              controller: _ipController,
              decoration: InputDecoration(
                labelText: 'IP',
              ),
            ),
            TextField(
              obscureText: false,
              controller: _portController,
              decoration: InputDecoration(
                labelText: 'Port',
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
    if(_portController.value.text.isEmpty || _ipController.value.text.isEmpty)return;
    int port = int.parse(_portController.value.text);
    var ip = _ipController.value.text;

    connectTo(ip, port);
  }

  void connectTo(String ip, int port) {
    Socket.connect(ip, port).then((Socket sock) {
      socket = sock;
      socket.listen(dataHandler,
          onError: errorHandler, onDone: doneHandler, cancelOnError: true);
    }).catchError((AsyncError e) {
      print("Unable to connect: $e");
    });
  }

  void dataHandler(data) {
    var text = new String.fromCharCodes(data).trim();
    var msg = new Message("NoYou", text);
    setState(() {
      messages.add(msg);
    });
    scrollDown();
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    socket.destroy();
  }

  void send() {
    if (socket == null) {
      connect();
      return;
    }
    var msg = new Message("You", myController.value.text.toString());
    setState(() {
      messages.add(msg);
    });
    socket.write(msg.text);
    socket.flush();
    myController.clear();
    scrollDown();
  }
void scrollDown(){
  // _scrollController.jumpTo(100.0 * messages.length);
  Timer(Duration(milliseconds: 10),()=>_scrollController.jumpTo(_scrollController.position.maxScrollExtent));

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ListView.separated(
        controller: _scrollController,
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: new BoxDecoration(
                color: messages[index].sender == "You"
                    ? Colors.grey
                    : Colors.lightGreen,
                borderRadius: new BorderRadius.all(new Radius.circular(10.0))),
            padding: EdgeInsets.all(10),
            child: Text('${messages[index]}'),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      )),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
              controller: myController,
              onSubmitted: (str) => send(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter a message',
                  contentPadding: EdgeInsets.all(5)),
            )),
            IconButton(
              icon: new Icon(Icons.send),
              onPressed: () => send(),
            )
          ],
        ),
      ),
    );
  }
}
