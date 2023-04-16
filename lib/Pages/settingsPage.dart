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
  @override
  void initState() {
    super.initState();
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
            child: Text("hello", style: TextStyle(color: darkTheme.textColor),),
          ),
        )
    );
  }
}