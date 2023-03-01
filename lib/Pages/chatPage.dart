import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:requests/requests.dart';

import '../messageWidget.dart';
import 'package:helli3chat_flutter/Themes/DarkTheme.dart';

class ChatPageState extends StatefulWidget {
  @override
  State<ChatPageState> createState() => ChatPage();
}

class ChatPage extends State<ChatPageState> {
  var messageLst = [];
  TextEditingController messageInputController = TextEditingController();
  ScrollController messageScrollController = ScrollController();
  String fullName = '';

  Future<void> readMessagesJson() async {
    DateTime dateTime = DateTime.now();
    print('http://37.32.28.222/all?zone=' + dateTime.timeZoneName + '&timestamp=' + dateTime.toString());
    var newRequest = await Requests.get('http://37.32.28.222/all?zone=' + dateTime.timeZoneName + '&date=' + dateTime.toString());
    newRequest.raiseForStatus();
    String requestBody = newRequest.content();

    // String currentDate = dateTime.year.toString() + "-" + dateTime.month.toString();
    //print(dateTime.toString());
    //print(dateTime.timeZoneName);

    //String requestBody = '[{"id":1,"text":"Hello 1","delivered":true,"senderid":1,"sent":true,"recieverid":2}, {"id":2,"text":"How are you?","delivered":true,"senderid":2,"sent":true,"recieverid":1}]';
    setState(() {
      List tempMessageListJSON = jsonDecode(requestBody);
      for (var messageDict in tempMessageListJSON) {
        if (messageDict["senderid"] == 1) {
          messageLst.add(Message(message: messageDict["text"], isSentBySelf: true));
        } else {
          messageLst.add(Message(message: messageDict["text"], isSentBySelf: false));
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    readMessagesJson();
  }

  void addMessageToList(bool isSentBySelf, var messageTxt) {
    setState(() {
      messageLst.add(Message(message: messageTxt, isSentBySelf: isSentBySelf));
    });
  }

  void scrollToMessageListBottom() {
    setState(() {
      messageScrollController.animateTo(messageScrollController.position.maxScrollExtent, duration: Duration(milliseconds: 1), curve: Curves.linear);
    });
  }

  Future<void> sendMessageToServer(String message) async {
    DateTime dateTime = DateTime.now();
    // String currentDate = dateTime.year.toString() + "-" + dateTime.month.toString();
    print(dateTime.toString());
    print(dateTime.timeZoneName);

    Map<String, String> headers = {
      "Content-Type": "application/json"
    };
    var newRequest = await Requests.post('http://37.32.28.222/new',
        body: {
          'text': message,
          'sent': false,
          'zone': dateTime.timeZoneName,
          'date': dateTime.toString(),
          'senderid': '527ae953-75e9-11ed-8d37-f1dc34e9f9cc',
          'receiverid': '527ae953-75e9-11ed-8d37-f1dc34e9f9cc'
        },
        bodyEncoding: RequestBodyEncoding.JSON,
        headers: headers
    );
    newRequest.raiseForStatus();
    String requestBody = newRequest.content();
  }

  void handleSendMessage() async {
    if (messageInputController.text != "") {
      addMessageToList(true, messageInputController.text.trim());
      sendMessageToServer(messageInputController.text.trim());

      messageInputController.clear();
      await Future.delayed(Duration(milliseconds: 5));
      scrollToMessageListBottom();
    }

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(child: Scaffold(
      backgroundColor: darkTheme.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Set this height
        child: PhysicalModel(
          color: darkTheme.appBarColor,
          elevation: 8,
          shadowColor: darkTheme.appBarColor,
          borderRadius: BorderRadius.circular(20),
          child: Container(
              color: darkTheme.appBarColor,
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => {},
                      icon: Icon(Icons.arrow_back, color: darkTheme.textColor),
                      label: Text(""),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 0, color: darkTheme.appBarColor)
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        'Test User',
                        style: TextStyle(
                          color: darkTheme.textColor,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              )
          ),
        )
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          color: darkTheme.backgroundColor,
          child: Column(
            children: [
              Expanded(child: SizedBox(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    children: [
                      Expanded(child: FractionallySizedBox(
                        heightFactor: 1,
                        child: Container(
                            child: GlowingOverscrollIndicator(
                              axisDirection: AxisDirection.down,
                              color: darkTheme.backgroundColor,
                              child: SingleChildScrollView(

                                  controller: messageScrollController,
                                  child: Column(
                                    children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                        for(var currentMessage in messageLst ) MessageWidget(message: currentMessage.message, isSentBySelf: currentMessage.isSentBySelf),

                                      ]),

                                    ],
                                  )
                              ),
                            )
                        ),
                      ))
                    ],
                  ),
                ),
              )),
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), color: darkTheme.secondryBackgroundColor),
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Row(
                      children: [
                        Expanded(child: Container(
                            constraints: BoxConstraints(minHeight: 50, maxHeight: 100),
                            child: TextField(

                              controller: messageInputController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: TextStyle(
                                color: darkTheme.textColor,
                                leadingDistribution: TextLeadingDistribution.even,

                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),

                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,

                                ),
                              ),
                              onChanged: (text) {
                                setState(() {
                                  fullName = text;
                                  //you can access nameController in its scope to get
                                  // the value of text entered as shown below
                                  //fullName = nameController.text;
                                });
                              },
                              onTap: () async {
                                if (messageScrollController.position.maxScrollExtent == messageScrollController.offset) {
                                  await Future.delayed(Duration(milliseconds: 185));
                                  scrollToMessageListBottom();
                                }

                              },
                            )
                        )),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8), color: darkTheme.primaryColor),

                          child: IconButton(
                            onPressed: handleSendMessage,
                            icon: Icon(Icons.send, color: darkTheme.secondryBackgroundColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
      ),
    ));
  }
}

class Message {
  final String message;
  final bool isSentBySelf;

  const Message({required this.message, required this.isSentBySelf});
}