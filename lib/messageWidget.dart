import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final bool isSentBySelf;

  const MessageWidget({required this.message, required this.isSentBySelf});

  @override
  Widget build(BuildContext context) {
    if (isSentBySelf) {
      return Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), color: Colors.grey),
                  padding: EdgeInsets.all(8),
                  child: Text(message,
                      style: TextStyle(
                        fontSize: 18,
                      )),
                )
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
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), color: Colors.green),
                  padding: EdgeInsets.all(8),
                  child: Text(message,
                      style: TextStyle(
                        fontSize: 18,
                      )),
                )
              ]

          ),
          SizedBox(height: 10),
        ],
      );
    }

  }
}