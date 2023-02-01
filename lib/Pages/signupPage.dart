import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:requests/requests.dart';
import 'package:helli3chat_flutter/Themes/DarkTheme.dart';

class SignUpPageState extends StatefulWidget {
  @override
  State<SignUpPageState> createState() => SignupPage();
}

class SignupPage extends State<SignUpPageState> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextEditingController usernameInputController = TextEditingController();
    TextEditingController passwordInputController = TextEditingController();
    TextEditingController repeatPasswordInputController = TextEditingController();
    TextEditingController phoneNumberInputController = TextEditingController();
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
                              Text("Sign Up", style: TextStyle(
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
                                      controller: usernameInputController,

                                      keyboardType: TextInputType.text,
                                      maxLines: null,
                                      style: TextStyle(
                                        color: darkTheme.textColor,
                                        leadingDistribution: TextLeadingDistribution.even,

                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        hintText: "Username...",
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
                              ),
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8), color: darkTheme.secondryBackgroundColor),
                                    child: TextField(
                                      cursorColor: darkTheme.primaryColor,
                                      controller: passwordInputController,

                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      style: TextStyle(
                                        color: darkTheme.textColor,
                                        leadingDistribution: TextLeadingDistribution.even,

                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        hintText: "Password...",
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
                              ),
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8), color: darkTheme.secondryBackgroundColor),
                                    child: TextField(
                                      cursorColor: darkTheme.primaryColor,
                                      controller: repeatPasswordInputController,

                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      style: TextStyle(
                                        color: darkTheme.textColor,
                                        leadingDistribution: TextLeadingDistribution.even,

                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        hintText: "Repeat Password...",
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
                              ),
                              Flexible(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8), color: darkTheme.secondryBackgroundColor),
                                    child: TextField(
                                      cursorColor: darkTheme.primaryColor,
                                      controller: phoneNumberInputController,

                                      keyboardType: TextInputType.phone,
                                      style: TextStyle(
                                        color: darkTheme.textColor,
                                        leadingDistribution: TextLeadingDistribution.even,

                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        hintText: "Phone...",
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
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: SizedBox(
                                    width: width,
                                    height: 40,
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),

                                      child: ElevatedButton(
                                          onPressed: () => {},
                                          style: ElevatedButton.styleFrom(
                                            primary: darkTheme.primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8), // <-- Radius
                                            ),
                                          ),

                                          child: Text("Continue", style: TextStyle(fontSize: 18),)
                                      ),
                                    )
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