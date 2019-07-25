import 'dart:async';
import 'dart:io';

import 'chat_List.dart';
import '../firebase_Connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';


final googleSignIn = new GoogleSignIn();
final auth = FirebaseAuth.instance;
var currentUserEmail;
var _scaffoldContext;
Uri downloadUrl;

class ChatScreen extends StatefulWidget {
  final String peerId;
  const ChatScreen({Key key, @required this.peerId}) : super(key: key);

  @override
  ChatScreenState createState() => new ChatScreenState(peerId:peerId);
  
}

class ChatScreenState extends State<ChatScreen> {
  final String peerId;
  Future<QuerySnapshot> query;
  String groupName,img;
  getGroupDetails() async
  {
    List<String> temp= await fireBaseConnection.getGroup(peerId);
    groupName=temp.elementAt(0);
    img=temp.elementAt(1);


  }
  ChatScreenState({Key key, @required this.peerId}) {
    getGroupDetails();
  
  }
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposingMessage = false;
  final reference = FirebaseDatabase.instance.reference().child('Chat');
  FireBaseConnection fireBaseConnection= new FireBaseConnection();
  
  // final ref = Firestore.instance.collection('Group').where('groupId', isEqualTo: ChatScreenState.peerId).getDocuments();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
        backgroundColor: Colors.teal,
        leading:new GestureDetector(
          child: Row(
            children:[
            new CircleAvatar(
              radius: 18,
              child: ClipOval(
                child: Image.network(
                  img,
                  height: 10.0,
                  width: 10.0,
                ),
              ),
            ),
            new Text(
              groupName,
              style: TextStyle(
                fontFamily: 'Cortanna',
                fontSize: 30.0,
              ),
            )
          ],
        ),
        onTap:()=>FlatButton(
            child:Text("Group Description"),
            onPressed:()=>(
              Text("Group ")
            ),
          ),
        ),
        actions: <Widget>[
          PopupMenuButton( 
            itemBuilder: (BuildContext context) { 
              return [ 
                PopupMenuItem(
                  child: FlatButton(
                    child: Text("Exit Group"),
                    onPressed: ()=>showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return new AlertDialog(
                        title: Text("Exit Group"),
                        content: const Text('Are you sure?'),
                        actions: <Widget>[
                          new FlatButton(
                            child:Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          new FlatButton(
                            child: const Text("Exit"),
                            onPressed: () {
                              
                            },
                          )
                        ],
                      );
                    },
                  ),
                  )
                  
                ),
              ]; 
            },
          )
        ],
      ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              Flexible(
                child: new FirebaseAnimatedList(
                query: reference,
                sort: (DataSnapshot a, DataSnapshot b) =>
                  b.key.compareTo(a.key),
                  padding: EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (BuildContext context, DataSnapshot messageSnapshot,
                      Animation<double> animation,_) {
                    return new ChatMessageListItem(messageSnapshot: messageSnapshot, animation: animation);
                  },
                )
              ),
              new Divider(height: 1.0),
              new Container(
                decoration:
                  new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
              new Builder(builder: (BuildContext context) {
                _scaffoldContext = context;
                return new Container(width: 0.0, height: 0.0);
              })
            ],
          ),
	        decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border: new Border(
                      top: new BorderSide(
                        color: Colors.grey[200],
                )))
              : null,
        ));
  }

CupertinoButton getIOSSendButton() {
  return new CupertinoButton(
    child: new Text("Send"),
    onPressed: _isComposingMessage
      ? () => _textMessageSubmitted(_textEditingController.text)
      : null,
    );
  }

IconButton getDefaultSendButton() {
  return new IconButton(
    icon: new Icon(Icons.send),
    onPressed: _isComposingMessage
        ? () => _textMessageSubmitted(_textEditingController.text)
        : null,
  );
}
Widget _buildTextComposer() {
  return new IconTheme(
      data: new IconThemeData(
        color: _isComposingMessage
          ? Theme.of(context).accentColor
          : Theme.of(context).disabledColor,
      ),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () async {
                  await fireBaseConnection.ensureLoggedIn();
                  File imageFile = await ImagePicker.pickImage(source:ImageSource.gallery);
                  int timestamp = new DateTime.now().millisecondsSinceEpoch;
                  StorageReference storageReference = FirebaseStorage
                      .instance
                      .ref()
                      .child("img_" + timestamp.toString() + ".jpg");
                  StorageTaskSnapshot snapshot = await storageReference.putFile(imageFile).onComplete;
                  _sendMessage(
                      messageText: null, imageUrl:(await snapshot.ref.getDownloadURL()).downloadUrl.toString(),dateTime:timestamp );
              }
            ),
          ),
          new Flexible(
            child: new TextField(
              controller: _textEditingController,
              onChanged: (String messageText) {
                setState(() {
                  _isComposingMessage = messageText.length > 0;
                });
              },
              onSubmitted: _textMessageSubmitted,
              decoration:
                  new InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          new Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Theme.of(context).platform == TargetPlatform.iOS
                ? getIOSSendButton()
                : getDefaultSendButton(),
          ),
        ],
      ),
    )
  );
}
Future<Null> _textMessageSubmitted(String text) async {
  int timestamp = new DateTime.now().millisecondsSinceEpoch;
  _textEditingController.clear();
  setState(() {
    _isComposingMessage = false;
  });
  await fireBaseConnection.ensureLoggedIn();
  _sendMessage(messageText: text, imageUrl: null,dateTime:timestamp);
}

void _sendMessage({String messageText, String imageUrl,int dateTime}) {
  reference.push().set({
    'groupId':peerId,
    'message/image': messageText,
    'message/image': imageUrl,
    'sendBy': googleSignIn.currentUser.displayName,
    'dateTime':dateTime,
  });
}
}
