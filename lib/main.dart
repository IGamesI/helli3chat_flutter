import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:helli3chat_flutter/routeGenerator.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'messageWidget.dart';
import 'package:helli3chat_flutter/Themes/DarkTheme.dart';
import 'Pages/chatPage.dart';
import 'Pages/loginPage.dart';
import 'Pages/signupPage.dart';
import 'Pages/profilePage.dart';
import 'Pages/settingsPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? token;
    Future<void> CheckForToken() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('Token');
      print(token);
    }
    CheckForToken();
    token = null;

    if (token == null) {
      return MaterialApp(
        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute,
      );
    } else {
      return MaterialApp(
        initialRoute: "/chat",
        onGenerateRoute: RouteGenerator.generateRoute,
      );
    }
  }
}

