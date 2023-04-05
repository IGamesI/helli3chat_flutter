import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:requests/requests.dart';
import 'package:helli3chat_flutter/Themes/DarkTheme.dart';

class ProfilePageState extends StatefulWidget {
  @override
  State<ProfilePageState> createState() => ProfilePage();
}

class ProfilePage extends State<ProfilePageState> {
  var imageData = null;
  var bytes = null;
  void _hashImageUrl() async {
    imageData = await rootBundle.load('assets/TestProfile.jpg');
    bytes = imageData.buffer.asUint8List();
  }

  String bio = "";
  String fullBio = "";
  String shortBio = "";
  bool showBioMoreButton = false;
  var bioButtonIcon = Icons.more_horiz;
  void _handleBio(String _bio) {
    List<String> words = _bio.split(" ");
    if (words.length > 50) {
      showBioMoreButton = true;

      String newString = "";
      for (int i = 0; i < 50 && i < words.length; i++) {
        newString += words[i] + " ";
      }
      bio = newString;
      fullBio = _bio;
      shortBio = newString;
    } else {
      bio = _bio;
      fullBio = _bio;
    }
  }
  void _showFullBio() {
    if (bio == shortBio) {
      bio = fullBio;
      bioButtonIcon = Icons.arrow_upward;
    } else {
      bio = shortBio;
      bioButtonIcon = Icons.more_horiz;
    }


    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    _hashImageUrl();
    _handleBio("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed auctor mi eu enim dapibus, quis ullamcorper mauris pretium. Quisque quis diam ac tellus auctor maximus vel in turpis. Nulla pretium feugiat justo, et dictum quam cursus sed. Suspendisse potenti. In hac habitasse platea dictumst. Sed ut quam tincidunt, placerat tortor vel, molestie tortor. Phasellus eget tempor sapien, in efficitur justo. Morbi imperdiet et elit ac ultrices. Donec rutrum ex non justo efficitur, non congue nisi suscipit. Aenean et mauris ac mi iaculis vestibulum vel nec felis. Pellentesque sollicitudin metus vel lectus ultricies, sit amet bibendum mauris ullamcorper. Fusce lacinia velit a sem imperdiet, quis mattis justo dictum. Fusce efficitur, massa eget convallis suscipit, sem turpis tristique nisi, non ultricies ipsum mauris sit amet libero. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Sed lobortis nunc orci, vel maximus elit laoreet et. Nunc id malesuada nisl, ac malesuada tellus. In vestibulum bibendum fringilla. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Sed nec aliquam dolor, vel iaculis lacus. Donec cursus turpis vel lacus faucibus, a elementum nisi finibus. Aliquam mollis, ex id porta feugiat, velit tortor semper diam, ut facilisis ligula nibh euismod tellus.");
  }

  String userName = "";
  String userPass = "";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextEditingController usernameInputController = TextEditingController();
    TextEditingController passwordInputController = TextEditingController();


    ScrollController pageScrollController = ScrollController();
    ScrollController bioScrollController = ScrollController();

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
                width: width,
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: bytes != null
                          ? MemoryImage(bytes)
                          : AssetImage('assets/TestProfile.jpg') as ImageProvider,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Text(
                        "UserName",
                        style: TextStyle(
                          color: darkTheme.textColor,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                      child: Text(
                        "09120999999999",
                        style: TextStyle(
                          color: darkTheme.secondryTextColor
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8), color: darkTheme.secondryBackgroundColor),
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            bio,
                            style: TextStyle(
                                color: darkTheme.textColor,
                                fontSize: 17
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: showBioMoreButton
                                ? GestureDetector(
                              onTap: () {
                                _showFullBio();
                              },
                              child: Icon(bioButtonIcon, color: darkTheme.textColor, size: 25,),
                            )
                                : Container()
                          )
                        ],
                      ),
                    )
                  ],
                )
            ),
          ),
        )
    );
  }
}