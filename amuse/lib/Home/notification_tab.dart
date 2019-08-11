//import 'themeFile.dart';
import 'dart:collection';

import 'package:amuse/Group/groupClass.dart';
import 'package:amuse/Location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../categorie.dart';
import '../fireBase_connection.dart';
import '../userClass.dart';

HashMap<String, UserGroup> currentGroups =new HashMap();
HashMap<String, Group> allGroups = new HashMap();
User user= new User();
ListCategories listCategories = new ListCategories();
class NotificationTab extends StatefulWidget{
  @override
  State createState() => NotificationTabState();
}

class NotificationTabState extends State<NotificationTab>{
  FireBaseConnection fireBaseConnection = new FireBaseConnection();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCategories();
  }


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
  getCurrentGroups()
  async {
    CollectionReference ref = Firestore.instance.collection('UserGroups');
    QuerySnapshot eventsQuery = await ref
        .where('userId', isEqualTo: user.userId)
        .getDocuments();
    if(eventsQuery.documents.length==0 || eventsQuery.documents.isEmpty)
      return 0;
    eventsQuery.documents.forEach((document)
    {
      currentGroups.putIfAbsent(document['groupId'], () => new UserGroup(document['groupId'] , document['mode']));
    });
  }
  getNewGroups() async
  {
    await getCurrentGroups();
    if(!listCategories.list.isEmpty)
    {
      for(Category c in listCategories.list.values )
      {
        for(String s in  c.subCat)
        {
          await Firestore.instance.collection('Group')
              .where('category', isEqualTo: c.mainCat)
              .where('subCat', isEqualTo: c.subCat).snapshots()
              .forEach((temp)
              {
                if(Location.getDistence(temp.documents[0]['geoPoint'] as Position, temp.documents[0]['area']))
                {
                  if(!currentGroups.containsKey(temp.documents[0]['groupId'])
                      && !allGroups.containsKey(temp.documents[0]['groupId']))
                    {
                      setState(() {
                        allGroups.putIfAbsent(temp.documents[0]['groupId'],
                                ()=> new Group.all(
                                temp.documents[0]['groupId'],
                                temp.documents[0]['groupName'],
                                temp.documents[0]['groupPicture'],
                                temp.documents[0]['category'],
                                temp.documents[0]['subCat'],
                                temp.documents[0]['description'],
                                temp.documents[0]['geoPoint'],
                                temp.documents[0]['area'],
                                temp.documents[0]['createdBy']
                            ));
                      });
                    }

                }
              });


        }

      }
      
    }

  }
  getCurrentGroupStatus() async
  {


  }
  getUserCategories()async
  {
    CollectionReference ref = Firestore.instance.collection('UserInterest');
    QuerySnapshot eventsQuery = await ref
        .where('userId', isEqualTo: user.userId)
        .getDocuments();
    if(eventsQuery.documents.length==0 || eventsQuery.documents.isEmpty)
      return 0;
    eventsQuery.documents.forEach((document)
    {
      listCategories.list.putIfAbsent(document["category"], () => new Category(document["category"].toString(),new List<String>(document["subcat"])));
    });

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
