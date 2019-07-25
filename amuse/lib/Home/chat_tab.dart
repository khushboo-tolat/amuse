//import 'themeFile.dart';
import 'package:flutter/material.dart';
import 'package:group/Group/createGroup.dart';

class ChatTab extends StatefulWidget{
  @override
  State createState() => ChatTabState();
}

class ChatTabState extends State<ChatTab>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 5.0),),

          ListTile(
            title: Text("Chat title", style: TextStyle(fontFamily: "Comfortaa", letterSpacing: 0.8,),),
            subtitle: Text("Chat content", style: TextStyle(fontFamily: "Comfortaa", letterSpacing: 0.8,),),
            leading: Container(
              height: 60,
              width: 60,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/user_default.png"),
                ),
              ),
            ),
          ),

          Padding(padding: EdgeInsets.fromLTRB(15, 0, 15, 0), child: Divider()),
        ],
      ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.group_add, size: 27,),
            onPressed: (){
              Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (context) => new CreateGroup(),
                      maintainState: true
                  )
              );
            },
        ),
    );
  }
}