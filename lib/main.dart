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
  TextEditingController nameController = TextEditingController();
  String fullName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // The title text which will be shown on the action bar
            centerTitle: true,
            title: Text("Helli3 Messanger"),
            backgroundColor: Color(0xff627764)),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
              Expanded(child: SizedBox(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Expanded(child: FractionallySizedBox(
                    heightFactor: 0.9,
                    child: Container(
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
                  )),
                ),
              )),
              Container(
                color: Colors.grey[400],
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    children: [
                      Expanded(child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Full Name',
                            ),
                            onChanged: (text) {
                              setState(() {
                                fullName = text;
                                //you can access nameController in its scope to get
                                // the value of text entered as shown below
                                //fullName = nameController.text;
                              });
                            },
                          )
                      )),
                      TextButton(onPressed: () {
                        setState(() {
                          messageLst.add(Message(message: nameController.text, isSentBySelf: true));
                        });
                      }, child: Text("Click Me!"))
                    ],
                  ),
                ),
              )
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