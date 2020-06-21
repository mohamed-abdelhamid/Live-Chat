import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class MessageContainer extends StatelessWidget {

  final String text  ;
  final bool isMe ;
  final Timestamp time ;

  MessageContainer({
    @required this.text ,
    @required this.isMe ,
    @required this.time ,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: isMe ? 50.0 : 7.0 , bottom: 3.0 , right: isMe ? 7.0 : 50.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${time.toDate().hour}.${time.toDate().minute}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(20.0) : Radius.zero ,
                topRight: isMe ? Radius.zero : Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              color: isMe ? Colors.white70 : Colors.blue[400],
            ),
            padding: EdgeInsets.only(left: 8.0 , right:  3.0 , bottom: 3.0 , top: 3.0),
            child: Text(
              '$text',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
