import 'package:flutter/material.dart';
import 'package:helli3chat_flutter/Themes/DarkTheme.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final bool isSentBySelf;
  final String userName;

  const MessageWidget({required this.message, required this.isSentBySelf, required this.userName});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (isSentBySelf) {
      return Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(child: Container(
                  constraints: BoxConstraints(minWidth: 10, maxWidth: width * 0.6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), color: darkTheme.primaryColor),
                  padding: EdgeInsets.all(8),
                  child: Text(message,
                      style: TextStyle(
                        color: darkTheme.backgroundColor,
                        fontSize: 18,
                      )),
                ))
              ]

          ),
          SizedBox(height: 10),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Flexible(child: Container(
                  constraints: BoxConstraints(minWidth: 10, maxWidth: width * 0.6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), color: darkTheme.secondryBackgroundColor),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userName,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 14,
                            color: darkTheme.primaryColor
                          ),
                          // textAlign: TextAlign.left
                        ),
                      SizedBox(height: 3,),
                      Text(message,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 18, color: darkTheme.textColor
                          )),
                    ],
                  ),
                ))
              ]

          ),
          SizedBox(height: 10),
        ],
      );
    }

  }
}