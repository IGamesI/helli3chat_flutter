import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:requests/requests.dart';
import 'package:helli3chat_flutter/Themes/DarkTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageState extends StatefulWidget {
  @override
  State<LoginPageState> createState() => LoginPage();
}

class LoginPage extends State<LoginPageState> {
  bool _passwordVisible = false;
  bool _repeatPasswordVisible = false;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _repeatPasswordVisible = false;
  }

  TextEditingController usernameInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();

  Future<void> sendSignUpMessageToServer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      "Content-Type": "application/json"
    };
    var newRequest = await Requests.post('http://37.32.28.222/signin',
        body: {
          'password': passwordInputController.text,
          'username': usernameInputController.text
        },
        bodyEncoding: RequestBodyEncoding.JSON,
        headers: headers
    );
    if (newRequest.statusCode == 403) {
      setErrorMessage("Username or Password Wrong!");
    } else if (newRequest.statusCode == 500) {
      setErrorMessage("Server Error!");
    } else if (newRequest.statusCode == 504) {
      setErrorMessage("Can't Connect to Server!");
    } else {
      String requestBody = newRequest.content();
      await prefs.setString('Token', requestBody);
      await prefs.setString('UserName', usernameInputController.text);
      Navigator.of(context).pushNamed('/chat');
    }

  }

  var ErrorMessage = "";
  void setErrorMessage(String _errorMessage) {
    setState(() {
      ErrorMessage = _errorMessage;
    });
  }

  void handleContinueButtonPress() async {
    if (usernameInputController.text != "" && passwordInputController.text != "") {
      sendSignUpMessageToServer();
    } else {
      setErrorMessage("Fill All Inputs");
    }

    sendSignUpMessageToServer();
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
            child: Container(
                color: darkTheme.backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
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
                                Container(
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
                                        )
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8), color: darkTheme.secondryBackgroundColor),
                                    child: TextField(
                                        cursorColor: darkTheme.primaryColor,
                                        controller: passwordInputController,

                                        keyboardType: TextInputType.text,
                                        obscureText: !_passwordVisible,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        style: TextStyle(
                                          color: darkTheme.textColor,
                                          leadingDistribution: TextLeadingDistribution.even,

                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(10, 14, 10, 0),
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
                                        )
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
                                            onPressed: () {
                                              handleContinueButtonPress();
                                            },
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
                                ),
                                if (ErrorMessage.isNotEmpty)
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8), color: darkTheme.errorColor),
                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    padding: EdgeInsets.all(10),
                                    child: Text(ErrorMessage, style: TextStyle(color: darkTheme.textColor)),
                                  )
                              ],
                            )
                        )
                    ),
                  ],
                )
            ),
          ),
        )
    );
  }
}