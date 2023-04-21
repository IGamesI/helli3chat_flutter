import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:requests/requests.dart';
import 'package:helli3chat_flutter/Themes/DarkTheme.dart';

class SettingsPageState extends StatefulWidget {
  @override
  State<SettingsPageState> createState() => SettingsPage();
}

class SettingsPage extends State<SettingsPageState> {
  TextEditingController bioInputController = TextEditingController();
  TextEditingController usernameInputController = TextEditingController();
  TextEditingController phoneInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();

  bool _passwordVisible = false;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    ScrollController pageScrollController = ScrollController();

    return Scaffold(
        backgroundColor: darkTheme.backgroundColor,
        appBar: AppBar(
          // The title text which will be shown on the action bar
            centerTitle: true,
            title: Text("Helli3 Messenger"),
            backgroundColor: darkTheme.appBarColor
        ),
        body: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          // the color you want to change in place of green
          color: darkTheme.backgroundColor,
          child: SingleChildScrollView(
            controller: pageScrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Container(
                    // height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), color: darkTheme.secondryBackgroundColor),
                    child: TextField(
                        maxLines: 10,
                        cursorColor: darkTheme.primaryColor,
                        controller: bioInputController,

                        keyboardType: TextInputType.text,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: TextStyle(
                          color: darkTheme.textColor,
                          leadingDistribution: TextLeadingDistribution.even,

                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 14, 10, 0),
                          hintText: "Bio...",
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

                            child: Text("Update Bio", style: TextStyle(fontSize: 18),)
                        ),
                      )
                  ),
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                  width: width,
                  color: darkTheme.secondryTextColor,
                ),

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
                        controller: usernameInputController,

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
                          hintText: "Username...",
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

                            child: Text("Update Username", style: TextStyle(fontSize: 18),)
                        ),
                      )
                  ),
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                  width: width,
                  color: darkTheme.secondryTextColor,
                ),

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
                        controller: phoneInputController,

                        keyboardType: TextInputType.phone,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: TextStyle(
                          color: darkTheme.textColor,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 14, 10, 10),
                          hintText: "Phone Number...",
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

                            child: Text("Update Phone Number", style: TextStyle(fontSize: 18),)
                        ),
                      )
                  ),
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                  width: width,
                  color: darkTheme.secondryTextColor,
                ),

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
                        controller: passwordInputController,
                        obscureText: !_passwordVisible,
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
                          hintText: "Password...",
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: darkTheme.primaryColor,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
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

                            child: Text("Update Password", style: TextStyle(fontSize: 18),)
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}