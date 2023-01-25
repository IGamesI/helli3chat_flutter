import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:requests/requests.dart';
import 'package:helli3chat_flutter/Themes/DarkTheme.dart';

class LoginPageState extends StatefulWidget {
  @override
  State<LoginPageState> createState() => LoginPage();
}

class LoginPage extends State<LoginPageState> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextEditingController fNameInputController = TextEditingController();
    String fName;

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                    constraints: BoxConstraints(minWidth: width/2, minHeight: width/2),
                    child: SizedBox(
                      height: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sign In", style: TextStyle(
                            color: darkTheme.textColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          )),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8), color: darkTheme.secondryBackgroundColor),
                                child: TextField(
                                    cursorColor: darkTheme.primaryColor,
                                    controller: fNameInputController,

                                    keyboardType: TextInputType.text,
                                    maxLines: null,
                                    style: TextStyle(
                                      color: darkTheme.textColor,
                                      leadingDistribution: TextLeadingDistribution.even,

                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      hintText: "First Name",
                                      hintStyle: TextStyle(
                                        color: darkTheme.textColor
                                      ),
                                      border: InputBorder.none,

                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                        borderSide: BorderSide(
                                            color: darkTheme.primaryColor,
                                            width: 3,
                                        ),

                                      ),
                                    ),
                                    // onChanged: (text) {
                                    //   setState(() {
                                    //     fName = text;
                                    //     //you can access nameController in its scope to get
                                    //     // the value of text entered as shown below
                                    //     //fullName = nameController.text;
                                    //   });
                                    // }
                                  // onTap: () async {
                                  //   if (messageScrollController.position.maxScrollExtent == messageScrollController.offset) {
                                  //     await Future.delayed(Duration(milliseconds: 185));
                                  //     scrollToMessageListBottom();
                                  //   }
                                  //
                                  // },
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    )
                ),
              )
            ],
          )
        )
    );
  }
}