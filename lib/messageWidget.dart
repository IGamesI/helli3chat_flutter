import 'package:flutter/material.dart';
import 'package:helli3chat_flutter/Themes/DarkTheme.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final bool isSentBySelf;

  const MessageWidget({required this.message, required this.isSentBySelf});

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
                      borderRadius: BorderRadius.circular(8), color: darkTheme.secondryBackgroundColor),
                  padding: EdgeInsets.all(8),
                  child: Text(message,
                      style: TextStyle(
                        color: darkTheme.textColor,
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
                      borderRadius: BorderRadius.circular(8), color: darkTheme.primaryColor),
                  padding: EdgeInsets.all(8),
                  child: Text(message,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: 18,

                      )),
                ))
              ]

          ),
          SizedBox(height: 10),
        ],
      );
    }

  }
}