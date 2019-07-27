import 'package:flutter/material.dart';
import 'profile_tab.dart';
import 'chat_tab.dart';
import 'notification_tab.dart';

class Home_Page extends StatefulWidget{
  @override
  State createState() => Home_PageState();
}

class Home_PageState extends State<Home_Page>{
  int _selectedIndex = 1;

  void ItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages = [
    new ProfileTab(),
    new ChatTab(),
    new NotificationTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,

      appBar: AppBar(
        title: Text(
          "amuse",
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.search,
                size: 30,
              )
          )
        ],
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text("Profile", style: TextStyle(fontFamily: "Comfortaa"),),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                title: Text("Chat", style: TextStyle(fontFamily: "Comfortaa"),)
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                title: Text("Notification", style: TextStyle(fontFamily: "Comfortaa"),)
            ),
          ],
        currentIndex: _selectedIndex,
        onTap: ItemTapped,
      ),
    );
  }
}