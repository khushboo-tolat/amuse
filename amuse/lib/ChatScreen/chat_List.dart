import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'const.dart';

var currentUserEmail;

class ChatMessageListItem extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;

  ChatMessageListItem({this.messageSnapshot, this.animation});
  var snapshot =  Firestore.instance.collection('Chat').snapshots();
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
      new CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children: currentUserEmail == messageSnapshot.value['sendBy']
              ? getSentMessageLayout(context)
              : getReceivedMessageLayout(context),
        ),
      ),
    );
  }
 List<Widget> getSentMessageLayout(BuildContext context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(messageSnapshot.value['sendBy'],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            new Container(
              decoration: BoxDecoration(color: greyColor2, borderRadius: BorderRadius.circular(8.0)),
              margin: const EdgeInsets.only(top: 5.0),
              child: messageSnapshot.value['message/image'] != null
                  ? new Image.network(
                messageSnapshot.value['message/image'],
                width: 250.0,
              )
                  : new Text(messageSnapshot.value['message/image']),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout(BuildContext context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(messageSnapshot.value['sendBy'],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            new Container(
              decoration: BoxDecoration(color: greyColor2, borderRadius: BorderRadius.circular(8.0)),
              margin: const EdgeInsets.only(top: 5.0),
              child: messageSnapshot.value['message/image'] != null
                  ? new Image.network(
                messageSnapshot.value['message/image'],
                width: 250.0,
              )
            :new Text(messageSnapshot.value['message/image']),
            ),
          ],
        ),
      ),
    ];
  }
}