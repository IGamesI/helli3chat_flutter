import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:requests/requests.dart';
import 'package:helli3chat_flutter/Themes/DarkTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPageState extends StatefulWidget {
  @override
  State<SignUpPageState> createState() => SignupPage();
}

class SignupPage extends State<SignUpPageState> {
  Future<void> resetSharedPrefrences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Token', "");
    await prefs.setString('UserName', "");
    print("cleared token!");
  }

  bool _passwordVisible = false;
  bool _repeatPasswordVisible = false;
  @override
  void initState() {
    super.initState();
    // resetSharedPrefrences();
    if (!isTokenChecked) {
      CheckForToken();
    }
    _passwordVisible = false;
    _repeatPasswordVisible = false;
  }

  TextEditingController usernameInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  TextEditingController repeatPasswordInputController = TextEditingController();
  TextEditingController phoneNumberInputController = TextEditingController();

  Future<void> sendSignInMessageToServer() async {
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

    if (newRequest.statusCode == 500) {
      setErrorMessage("Server Error!");
    } else {
      String requestBody = newRequest.content();
      await prefs.setString('Token', requestBody);
      await prefs.setString('UserName', usernameInputController.text);
      Navigator.of(context).pushNamed('/chat');
    }
  }
  Future<void> sendSignUpMessageToServer() async {
    Map<String, String> headers = {
      "Content-Type": "application/json"
    };
    var newRequest = await Requests.post('http://37.32.28.222/signup',
        body: {
          'bio': "",
          'password': passwordInputController.text,
          'phone': phoneNumberInputController.text,
          'profile': "",
          'username': usernameInputController.text
        },
        bodyEncoding: RequestBodyEncoding.JSON,
        headers: headers
    );
    //newRequest.raiseForStatus();
    String requestBody = newRequest.content();
    if (newRequest.statusCode == 400) {
      setErrorMessage("Username Already Exists");
    } else if (newRequest.statusCode == 500) {
      setErrorMessage("Couldn't Create Account!");
    } else if (newRequest.statusCode == 504) {
      setErrorMessage("Can't Connect to Server!");
    } else {
      sendSignInMessageToServer();
    }
  }

  var ErrorMessage = "";
  void setErrorMessage(String _errorMessage) {
    setState(() {
      ErrorMessage = _errorMessage;
    });
  }
  void handleContinueButtonPress() async {
    if (usernameInputController.text != "" && passwordInputController.text != "" && repeatPasswordInputController.text != "" && phoneNumberInputController != "") {
      if (repeatPasswordInputController.text == passwordInputController.text) {
        sendSignUpMessageToServer();
      } else {
        setErrorMessage("Passwords Don't Match!");
      }
    } else {
      setErrorMessage("Fill All Inputs");
    }
  }

  bool isTokenChecked = false;
  String? token;
  Future<void> CheckForToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('Token');
    print(token);

    if (token != null && token != "") {
      Navigator.of(context).pushNamed('/chat');
    }
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
                            height: 480,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Sign Up", style: TextStyle(
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
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8), color: darkTheme.secondryBackgroundColor),
                                    child: TextField(
                                      cursorColor: darkTheme.primaryColor,
                                      controller: repeatPasswordInputController,

                                      keyboardType: TextInputType.text,
                                      obscureText: !_repeatPasswordVisible,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      style: TextStyle(
                                        color: darkTheme.textColor,
                                        leadingDistribution: TextLeadingDistribution.even,

                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(10, 14, 10, 0),
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

                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            // Based on passwordVisible state choose the icon
                                            _repeatPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: darkTheme.primaryColor,
                                          ),
                                          onPressed: () {
                                            // Update the state i.e. toogle the state of passwordVisible variable
                                            setState(() {
                                              _repeatPasswordVisible = !_repeatPasswordVisible;
                                              
                                            });
                                          },
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
                                TextButton(onPressed: () {Navigator.of(context).pushNamed('/login');}, child: Text("Sign In")),
                                if (ErrorMessage.isNotEmpty)
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8), color: darkTheme.errorColor),
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