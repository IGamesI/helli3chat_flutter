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
    var newRequest = await Requests.get('http://37.32.28.222/all');
    newRequest.raiseForStatus();
    String requestBody = newRequest.content();
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
    Map<String, String> params = {
      "text": message,
      "sent": "false",
      "senderid": "527ae953-75e9-11ed-8d37-f1dc34e9f9cc",
      "receiverid": "527ae953-75e9-11ed-8d37-f1dc34e9f9cc",
    };

    Map<String, String> headers = {
      "Content-Type": "application/json"
    };
    var newRequest = await Requests.post('http://37.32.28.222/new',
        body: {
          'text': message,
          'sent': false,
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
    return Scaffold(
        appBar: AppBar(
          // The title text which will be shown on the action bar
            centerTitle: true,
            title: Text("Helli3 Messenger"),
            backgroundColor: darkTheme.appBarColor
        ),
        body: Container(
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
        ));
  }
}

class Message {
  final String message;
  final bool isSentBySelf;

  const Message({required this.message, required this.isSentBySelf});
}