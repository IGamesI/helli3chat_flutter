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
  final String data;
  ChatPageState({required this.data,});

  @override
  State<ChatPageState> createState() => ChatPage(chatId: data);
}

class ChatPage extends State<ChatPageState> {
  final String chatId;
  ChatPage({required this.chatId,});

  var messageLst = [];
  var messageIdLst = [];
  TextEditingController messageInputController = TextEditingController();
  TextEditingController membernameInputController = TextEditingController();
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
  Future<void> readMessagesJson() async {
    // print("---- request started! " + DateTime.now().toString() + " ----");
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      DateTime dateTime = DateTime.now();
      //final String? lastUpdatedDate = prefs.getString('lastUpdatedTime');
      // final String? lastUpdatedDate = null;

      var newRequest;
      Map<String, String> headers = {
        "Token": userToken.toString().replaceAll('\n', '').replaceAll('"', '')
      };
      if (lastUpdatedDateVar == "") {
        DateTime startDate = dateTime.subtract(Duration(days: 365));
        print("------" + 'http://37.32.28.222/all?zone=' + dateTime.timeZoneName + '&date=' + startDate.toString().replaceAll(' ', '@'));
        if (chatId == "Global") {
          newRequest = await Requests.get('http://37.32.28.222/all?zone=' + "+0330" + '&date=' + startDate.toString().replaceAll(' ', '@'), headers: headers);
        } else {
          newRequest = await Requests.get('http://37.32.28.222/all?zone=' + "+0330" + '&date=' + startDate.toString().replaceAll(' ', '@') + "&chatid=" + chatId, headers: headers);
        }
        // print("YYYYY current time");
      } else {
        print("------" + 'http://37.32.28.222/all?zone=' + dateTime.timeZoneName + '&date=' + lastUpdatedDateVar.replaceAll(' ', '@'));
        if (chatId == "Global") {
          newRequest = await Requests.get('http://37.32.28.222/all?zone=' + "+0330" + '&date=' + lastUpdatedDateVar.replaceAll(' ', '@') , headers: headers);
        } else {
          newRequest = await Requests.get('http://37.32.28.222/all?zone=' + "+0330" + '&date=' + lastUpdatedDateVar.replaceAll(' ', '@') + "&chatid=" + chatId, headers: headers);
        }
        // print("YYYYY current time: " + DateTime.now().toString() + " fetching time: " + lastUpdatedDateVar);
      }
      // print(newRequest.statusCode);
      if (newRequest.statusCode != 502) {
        //await prefs.setString('lastUpdatedTime', dateTime.toString());
        lastUpdatedDateVar = dateTime.toString();
        String requestBody = newRequest.body;
        //print("xxxxxx" + requestBody + "xxxxxxx");
        //scrollToMessageListBottom();
        //String requestBody = '[{"id":1,"text":"Hello 1","delivered":true,"senderid":1,"sent":true,"recieverid":2}, {"id":2,"text":"How are you?","delivered":true,"senderid":2,"sent":true,"recieverid":1}]';
        setState(() {
          List tempMessageListJSON = jsonDecode(requestBody);
          for (var messageDict in tempMessageListJSON) {
            if (messageDict["senderid"] == "self") {
              if (messageIdLst == []) {
                messageLst.add(Message(message: messageDict["text"], isSentBySelf: true, userName: "Self", messageId: messageDict["id"]));
                messageIdLst.add(messageDict["id"]);
              } else if (!messageIdLst.contains(messageDict["id"])) {
                messageLst.add(Message(message: messageDict["text"], isSentBySelf: true, userName: "Self", messageId: messageDict["id"]));
                messageIdLst.add(messageDict["id"]);
                print("zzzzz current message id= " + messageDict["id"] + " message id list= " + messageIdLst.toString());
              }
            } else {
              if (messageDict == []) {
                messageLst.add(Message(message: messageDict["text"], isSentBySelf: false, userName: messageDict["senderid"], messageId: messageDict["id"]));
                messageIdLst.add(messageDict["id"]);
              } else if (!messageIdLst.contains(messageDict["id"]))
                messageLst.add(Message(message: messageDict["text"], isSentBySelf: false, userName: messageDict["senderid"], messageId: messageDict["id"]));
                messageIdLst.add(messageDict["id"]);
              print("zzzzz current message id= " + messageDict["id"] + " message id list= " + messageIdLst.toString());
            }
          }
        });
        // print("---- request ended! " + DateTime.now().toString() + " ----");
        await Future.delayed(Duration(milliseconds: 300));
        scrollToMessageListBottom();
      } else {
        print("serverDown");
      }
    } catch(e) {
      print("no message!");
    }
  }

  void syncMessageLoop() async {
    await readMessagesJson();
    Timer(Duration(seconds: 1), () => syncMessageLoop());
  }

  @override
  void initState() {
    super.initState();
    _hashImageUrl();
    readToken();
    readMessagesJson();
    Timer syncMessageTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      readMessagesJson();
    });
    // syncMessageLoop();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   scrollToMessageListBottom();
    // });
  }

  void addMessageToList(bool isSentBySelf, var messageTxt) {
    setState(() {
      messageLst.add(Message(message: messageTxt, isSentBySelf: isSentBySelf, userName: "Self", messageId: ""));
    });
  }

  void scrollToMessageListBottom() {
    setState(() {
      //messageScrollController.animateTo(messageScrollController.position.maxScrollExtent, duration: Duration(milliseconds: 1), curve: Curves.linear);
      if (messageScrollController.hasClients) {
        final position = messageScrollController.position.maxScrollExtent;
        messageScrollController.jumpTo(position);
      }
      // print("----- scroll to bottom -----");
    });
  }

  Future<void> sendMessageToServer(String message) async {
    DateTime dateTime = DateTime.now();
    // String currentDate = dateTime.year.toString() + "-" + dateTime.month.toString();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Token": userToken.toString().replaceAll('\n', '').replaceAll('"', '')
    };
    var newRequest;
    if (chatId == "Global") {
      newRequest = await Requests.post('http://37.32.28.222/new',
          body: {
            'text': message,
            'sent': true,
            'zone': "+0330",
            'date': dateTime.toString().replaceAll(' ', '@'),
            // 'senderid': '2906df21-e038-11ed-af64-16606bc3cbcc',
            'chatid': '5dfa2b61-e038-11ed-af64-16606bc3cbcc'
          },
          bodyEncoding: RequestBodyEncoding.JSON,
          headers: headers
      );
    } else {
      newRequest = await Requests.post('http://37.32.28.222/new',
          body: {
            'text': message,
            'sent': true,
            'zone': "+0330",
            'date': dateTime.toString().replaceAll(' ', '@'),
            // 'senderid': '2906df21-e038-11ed-af64-16606bc3cbcc',
            'chatid': chatId
          },
          bodyEncoding: RequestBodyEncoding.JSON,
          headers: headers
      );
    }
    newRequest.raiseForStatus();
    String requestBody = newRequest.content();
    // lastUpdatedDateVar = DateTime.now().add(Duration(seconds: 1)).toString();
  }

  void handleSendMessage() async {
    if (messageInputController.text != "") {
      //addMessageToList(true, messageInputController.text.trim());
      sendMessageToServer(messageInputController.text.trim());

      messageInputController.clear();
      await Future.delayed(Duration(milliseconds: 100));
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
    double width = MediaQuery.of(context).size.width;

    Container AddUsersBotttomSheet() {
      return Container(
          color: darkTheme.backgroundColor,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Wrap(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Container(
                    // height: 50,
                    // padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), color: darkTheme.secondryBackgroundColor),
                    child: TextField(
                        cursorColor: darkTheme.primaryColor,
                        controller: membernameInputController,

                        keyboardType: TextInputType.text,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: TextStyle(
                          color: darkTheme.textColor,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 14, 10, 10),
                          hintText: "New Member Username...",
                          hintStyle: TextStyle(
                            color: darkTheme.textColor,
                          ),
                          border: InputBorder.none,

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: darkTheme.primaryColor,
                              width: 3,
                            ),

                          ),
                        )
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: SizedBox(
                      width: width,
                      height: 40,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(25, 0, 25, 0),

                        child: ElevatedButton(
                            onPressed: () {
                            },
                            style: ElevatedButton.styleFrom(
                              primary: darkTheme.secondryBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8), // <-- Radius
                              ),
                            ),

                            child: Text("Add Member", style: TextStyle(fontSize: 18),)
                        ),
                      )
                  ),
                ),
              ],
            ),
          )
      );
    }

    return SafeArea(child: Scaffold(
      backgroundColor: darkTheme.backgroundColor,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(60), // Set this height
      //   child: PhysicalModel(
      //     color: darkTheme.appBarColor,
      //     elevation: 8,
      //     shadowColor: darkTheme.appBarColor,
      //     borderRadius: BorderRadius.circular(20),
      //     child: Container(
      //         color: darkTheme.appBarColor,
      //         height: 80,
      //         child: Padding(
      //           padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               // Container(
      //               //   padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      //               //   child: GestureDetector(
      //               //     onTap: () => {},
      //               //     child: Icon(Icons.arrow_back, color: darkTheme.textColor),
      //               //   ),
      //               // ),
      //               // CircleAvatar(
      //               //   backgroundImage: bytes != null
      //               //       ? MemoryImage(bytes)
      //               //       : AssetImage('assets/TestProfile.jpg') as ImageProvider,
      //               // ),
      //               Padding(
      //                 padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      //                 child: Text(
      //                   chatId,
      //                   style: TextStyle(
      //                     color: darkTheme.textColor,
      //                     fontSize: 18,
      //                     fontWeight: FontWeight.bold
      //                   ),
      //                   textAlign: TextAlign.center,
      //                 ),
      //               )
      //             ],
      //           ),
      //         )
      //     ),
      //   )
      // ),
      appBar: AppBar(
        // The title text which will be shown on the action bar
          centerTitle: true,
          title: Text("Helli3 Messenger"),
          backgroundColor: darkTheme.appBarColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) {
                  return AddUsersBotttomSheet();
                });
              },
            )
          ],
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                await Future.delayed(Duration(milliseconds: 385));
                                scrollToMessageListBottom();
                                // if (messageScrollController.position.maxScrollExtent == messageScrollController.offset) {
                                //   await Future.delayed(Duration(milliseconds: 385));
                                //   scrollToMessageListBottom();
                                // }

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
  final String messageId;

  const Message({required this.message, required this.isSentBySelf, required this.userName, required this.messageId});
}