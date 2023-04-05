import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:requests/requests.dart';

import 'messageWidget.dart';
import 'package:helli3chat_flutter/Themes/DarkTheme.dart';
import 'Pages/chatPage.dart';
import 'Pages/loginPage.dart';
import 'Pages/signupPage.dart';
import 'Pages/profilePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePageState(),
    );
  }
}

