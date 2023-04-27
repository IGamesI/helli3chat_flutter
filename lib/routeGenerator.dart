import 'package:flutter/material.dart';
import 'package:helli3chat_flutter/Pages/chatListPage.dart';
import 'package:helli3chat_flutter/Pages/chatPage.dart';
import 'package:helli3chat_flutter/Pages/loginPage.dart';
import 'package:helli3chat_flutter/Pages/profilePage.dart';
import 'package:helli3chat_flutter/Pages/settingsPage.dart';
import 'package:helli3chat_flutter/Pages/signupPage.dart';
import 'package:helli3chat_flutter/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SignUpPageState());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPageState());
      case '/chatlist':
        return MaterialPageRoute(builder: (BuildContext context) {
          return WillPopScope(child: ChatListPageState(), onWillPop: () async => false);
        });
      case "/chat":
        return MaterialPageRoute(builder: (_) => ChatPageState(data: args.toString(),));
      case "/settings":
        return MaterialPageRoute(builder: (_) => SettingsPageState());
      case "/profile":
        return MaterialPageRoute(builder: (_) => ProfilePageState());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(
          child: Text("Error"),
        ),
      );
    });
  }
}