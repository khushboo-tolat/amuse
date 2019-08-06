import 'package:flutter/material.dart';
import '../fireBase_connection.dart';

class NotificationTab extends StatefulWidget{
  @override
  State createState() => NotificationTabState();
}

class NotificationTabState extends State<NotificationTab>{
  FireBaseConnection fireBaseConnection = new FireBaseConnection();


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                Container(
                  child: Material(
                    color: Colors.teal,
                    child: TabBar(
                      tabs: [
                        Tab(
                          child: Text('Current Groups'),
                        ),
                        Tab(
                          child: Text('Other Groups'),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      showCurrentGroups(),
                      showOtherGroups(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget showCurrentGroups(){
    return GestureDetector(
      child: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 5.0),),

          ListTile(
            title: Text("Group title", style: TextStyle(fontFamily: "Comfortaa", letterSpacing: 0.8,),),
            subtitle: Text("Group content", style: TextStyle(fontFamily: "Comfortaa", letterSpacing: 0.8,),),
            leading: Container(
              height: 60,
              width: 60,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/group_default.png"),
                ),
              ),
            ),
          ),

          Padding(padding: EdgeInsets.fromLTRB(15, 0, 15, 0), child: Divider()),
        ],
      ),
      onTap: (){
        var groupId = 'qwerty';
        showCurrentGroupDialog(groupId);
      },
    );
  }

  Widget showOtherGroups(){
    return GestureDetector(
      child: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 5.0),),

          ListTile(
            title: Text("Group title", style: TextStyle(fontFamily: "Comfortaa", letterSpacing: 0.8,),),
            subtitle: Text("Group content", style: TextStyle(fontFamily: "Comfortaa", letterSpacing: 0.8,),),
            leading: Container(
              height: 60,
              width: 60,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/group_default.png"),
                ),
              ),
            ),
          ),

          Padding(padding: EdgeInsets.fromLTRB(15, 0, 15, 0), child: Divider()),
        ],
      ),
      onTap: (){
        showOtherGroupDialog();
      },
    );
  }

  Widget showCurrentGroupDialog(groupId) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(Icons.warning, color: Colors.redAccent,),
              Padding(padding: EdgeInsets.only(right: 5),),
              Text(
                'Warning!!',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Comfortaa",
                ),
              ),
            ],
          ),
          content: Text(
            'You are of out of the radius of this group.',
            style: TextStyle(
              fontFamily: "Comfortaa",
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () async{
                await fireBaseConnection.deleteUser(groupId);
              },
              child: Text(
                'Exit Group',
                style: TextStyle(
                    color: Colors.teal,
                    fontFamily: "Comfortaa",
                    fontSize: 15
                ),
              )
            ),
            FlatButton(
              onPressed: () async{
                await fireBaseConnection.offlineUser(groupId);
              },
              child: Text(
                'Offline Mode',
                style: TextStyle(
                    color: Colors.teal,
                    fontFamily: "Comfortaa",
                    fontSize: 15
                ),
              )
            ),
          ],
        );
      }
    );
  }

  Widget showOtherGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
        );
      }
    );
  }
}
