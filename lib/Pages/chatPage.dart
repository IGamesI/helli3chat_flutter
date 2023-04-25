import 'dart:async';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String userToken = "";
  String userName = "";
  Future<void> readToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('Token')!;
    userName = prefs.getString('UserName')!;
  }

  String lastUpdatedDateVar = "";
  // bool isFirstFetchDone = ;
  Future<void> readMessagesJson() async {
    print("------ loading messages!");
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    DateTime dateTime = DateTime.now();
    //final String? lastUpdatedDate = prefs.getString('lastUpdatedTime');
    // final String? lastUpdatedDate = null;

    var newRequest;
    Map<String, String> headers = {
      "Token": userToken.toString().replaceAll('\n', '').replaceAll('"', '')
    };
    print("---------------" + headers.toString());
    if (lastUpdatedDateVar == "") {
      DateTime startDate = dateTime.subtract(Duration(days: 365));
      print("------" + 'http://37.32.28.222/all?zone=' + dateTime.timeZoneName + '&date=' + startDate.toString().replaceAll(' ', '@'));
      newRequest = await Requests.get('http://37.32.28.222/all?zone=' + "+0330" + '&date=' + startDate.toString().replaceAll(' ', '@'), headers: headers);
    } else {
      print("------" + 'http://37.32.28.222/all?zone=' + dateTime.timeZoneName + '&date=' + lastUpdatedDateVar.replaceAll(' ', '@'));
      newRequest = await Requests.get('http://37.32.28.222/all?zone=' + "+0330" + '&date=' + lastUpdatedDateVar.replaceAll(' ', '@'), headers: headers);
    }
    // print(newRequest.statusCode);
    if (newRequest.statusCode != 502) {
      //await prefs.setString('lastUpdatedTime', dateTime.toString());
      lastUpdatedDateVar = dateTime.toString();
      String requestBody = newRequest.body;
      scrollToMessageListBottom();
      //String requestBody = '[{"id":1,"text":"Hello 1","delivered":true,"senderid":1,"sent":true,"recieverid":2}, {"id":2,"text":"How are you?","delivered":true,"senderid":2,"sent":true,"recieverid":1}]';
      setState(() {
        List tempMessageListJSON = jsonDecode(requestBody);
        for (var messageDict in tempMessageListJSON) {
          if (messageDict["senderid"] == "self") {
            messageLst.add(Message(message: messageDict["text"], isSentBySelf: true, userName: "Self"));
          } else {
            messageLst.add(Message(message: messageDict["text"], isSentBySelf: false, userName: messageDict["senderid"]));
          }
        }
      });
    } else {
      print("serverDown");
    }

  }

  @override
  void initState() {
    super.initState();
    _hashImageUrl();
    readToken();
    readMessagesJson();
    Timer syncMessageTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      readMessagesJson();
    });
  }

  void addMessageToList(bool isSentBySelf, var messageTxt) {
    setState(() {
      messageLst.add(Message(message: messageTxt, isSentBySelf: isSentBySelf, userName: "Self"));
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
      "Content-Type": "application/json",
      "Token": userToken.toString().replaceAll('\n', '').replaceAll('"', '')
    };
    var newRequest = await Requests.post('http://37.32.28.222/new',
        body: {
          'text': message,
          'sent': true,
          'zone': dateTime.timeZoneName,
          'date': dateTime.toString().replaceAll(' ', '@'),
          // 'senderid': '2906df21-e038-11ed-af64-16606bc3cbcc',
          'chatid': '5dfa2b61-e038-11ed-af64-16606bc3cbcc'
        },
        bodyEncoding: RequestBodyEncoding.JSON,
        headers: headers
    );
    newRequest.raiseForStatus();
    String requestBody = newRequest.content();
  }

  void handleSendMessage() async {
    if (messageInputController.text != "") {
      //addMessageToList(true, messageInputController.text.trim());
      sendMessageToServer(messageInputController.text.trim());

      messageInputController.clear();
      await Future.delayed(Duration(milliseconds: 5));
      scrollToMessageListBottom();
    }

  }

  var imageData = null;
  var bytes = null;

  void _hashImageUrl() async {
    imageData = await rootBundle.load('assets/TestProfile.jpg');
    bytes = imageData.buffer.asUint8List();
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
                padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    //   child: GestureDetector(
                    //     onTap: () => {},
                    //     child: Icon(Icons.arrow_back, color: darkTheme.textColor),
                    //   ),
                    // ),
                    // CircleAvatar(
                    //   backgroundImage: bytes != null
                    //       ? MemoryImage(bytes)
                    //       : AssetImage('assets/TestProfile.jpg') as ImageProvider,
                    // ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        'Global Chat',
                        style: TextStyle(
                          color: darkTheme.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
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
                                        for(var currentMessage in messageLst ) MessageWidget(message: currentMessage.message, isSentBySelf: currentMessage.isSentBySelf, userName: currentMessage.userName,),

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
  final String userName;

  const Message({required this.message, required this.isSentBySelf, required this.userName});
}