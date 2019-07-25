import 'package:flutter/material.dart';
import '../UserDetails/update_profile.dart';
import '../UserDetails/update_category.dart';
import '../UserDetails/update_pin.dart';
import '../userClass.dart';

class ProfileTab extends StatefulWidget{
  @override
  State createState() => ProfileTabState();
}

class ProfileTabState extends State<ProfileTab>{
  User user = new User();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
              Center(
                child: FlatButton(
                  child:Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 40),),

                      Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(user.profilePicture),
                              fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(80)
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(top: 20),),

                      Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Comfortaa",
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ],
                  ),
                  onPressed: (){
                    Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (context) => new update_profile(),
                            maintainState: true
                        )
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Divider(color: Colors.grey,),
              ),

              ListTile(
                title: Text(
                  "Edit Category",
                  style: TextStyle(
                    fontFamily: "Comfortaa",
                    letterSpacing: 1.3,
                  ),
                ),
                leading: Icon(
                  Icons.category,
                  color: Colors.teal,
                ),
                onTap: (){
                  Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (context) => new update_category(),
                          maintainState: true
                      )
                  );
                },
              ),

              ListTile(
                title: Text("Change Pin", style: TextStyle(fontFamily: "Comfortaa", letterSpacing: 1.3,),),
                leading: Icon(Icons.vpn_key, color: Colors.teal,),
                onTap: (){
                  Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (context) => new update_pin(),
                          maintainState: true
                      )
                  );
                },
              ),

            ListTile(
              title: Text("Settings", style: TextStyle(fontFamily: "Comfortaa", letterSpacing: 1.3,),),
              leading: Icon(Icons.settings, color: Colors.teal,),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
              child: Divider(color: Colors.grey,),
            ),

            Center(
              child: RaisedButton(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: Text("Log Out", style: TextStyle(fontFamily: "Comfortaa", fontSize: 17, color: Colors.white, letterSpacing: 1.5),),
                  ),
                  color: Colors.red,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)
                  ),
                  onPressed: (){},
              ),
            )
          ],
        ),
      ),
    );
  }
}