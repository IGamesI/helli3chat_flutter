import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:requests/requests.dart';
import 'package:helli3chat_flutter/Themes/DarkTheme.dart';

class ChatListPageState extends StatefulWidget {
  @override
  State<ChatListPageState> createState() => ChatListPage();
}

class ChatListPage extends State<ChatListPageState> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    ScrollController pageScrollController = ScrollController();
    TextEditingController chatnameInputController = TextEditingController();

    Container NewChatBottomSheet() {
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
                        controller: chatnameInputController,

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
                          hintText: "Chat Name...",
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

                            child: Text("Add Chat", style: TextStyle(fontSize: 18),)
                        ),
                      )
                  ),
                ),
              ],
            ),
          )
      );
    }

    return Scaffold(
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
                height: 80,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 40, 5, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
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
                          "Chat List",
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
        body: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          // the color you want to change in place of green
          color: darkTheme.backgroundColor,
          child: SingleChildScrollView(
              controller: pageScrollController,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 60,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child:ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/chat', arguments: "Global");
                        },
                        style: ElevatedButton.styleFrom(
                          primary: darkTheme.secondryBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // <-- Radius
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.chat),
                            ),
                            Text(
                              "Global Chat",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child:ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: darkTheme.secondryBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // <-- Radius
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.chat),
                            ),
                            Text(
                              "Chat 1",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
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
                                  showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) {
                                    return NewChatBottomSheet();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: darkTheme.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // <-- Radius
                                  ),
                                ),

                                child: Text("New Chat", style: TextStyle(fontSize: 18),)
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              )
          ),
        )
    );
  }
}