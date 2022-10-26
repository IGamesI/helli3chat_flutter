import 'package:flutter/material.dart';
import 'messageWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var messageLst = [Message(message: "meow2", isSentBySelf: false), Message(message: "meow3", isSentBySelf: true), Message(message: "meow5", isSentBySelf: false)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // The title text which will be shown on the action bar
            centerTitle: true,
            title: Text("Helli3 Messanger"),
            backgroundColor: Color(0xff627764)),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              Container(
                height: 500,
                child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                          for(var currentMessage in messageLst ) MessageWidget(message: currentMessage.message, isSentBySelf: currentMessage.isSentBySelf),

                        ]),

                      ],
                    )
                ),
              ),
              TextButton(onPressed: () {
                setState(() {
                  messageLst.add(Message(message: "meow4", isSentBySelf: true));
                });
              }, child: Text("Click Me!"))
            ],
          )
        ));
  }
}

class Message {
  final String message;
  final bool isSentBySelf;

  const Message({required this.message, required this.isSentBySelf});
}