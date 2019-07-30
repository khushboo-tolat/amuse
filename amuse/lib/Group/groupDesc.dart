import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../userClass.dart';
import '../Home/home.dart';
import '../Validation/validationClass.dart';
import '../fireBase_connection.dart';

class groupDesc extends StatefulWidget{
  String gId;
  groupDesc(id){
    this.gId = id;
  }

  @override
  State<StatefulWidget> createState() => groupDescState(gId);
}

class groupDescState extends State<groupDesc>{
  FireBaseConnection fireBaseConnection = new FireBaseConnection();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  User user = new User();
  var length;
  String groupId;

  groupDescState(id) {
    this.groupId = id;
  }
  File file;

  void initState() {
    fireBaseConnection.countMembers(groupId).then((result) {
      setState(() {
        length = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('Group').where('groupId', isEqualTo: groupId).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData)
            return Text("Group data not found....");
          var ID = snapshot.data.documents[0].documentID;
          var adminID = snapshot.data.documents[0]['createdBy'];
          var userID = user.userId;

          return ListView(
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      if(userID == adminID) {
                        showChoiceDailog();
                        String str= fireBaseConnection.uploadImage(file, snapshot.data.documents[0]['groupId']).toString();
                        fireBaseConnection.updateGroupPic(str, groupId);
                      }
                    },
                    child: Image(
                      image: (NetworkImage(snapshot.data.documents[0]['groupPic']) != null)
                          ?NetworkImage(snapshot.data.documents[0]['groupPic'])
                          :AssetImage('assets/images/group_default.png'),
                      fit: BoxFit.fill,
                      height: 350,
                      width: 420,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 10),
                    child: Container(
                      child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: <Widget>[
                          Container(
                            width: 390,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data.documents[0]['groupName'],
                                  style: TextStyle(
                                      fontFamily: "Comfortaa",
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 5),),
                              ],
                            ),
                          ),
                          (userID==adminID)?IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.white,
                            iconSize: 25,
                            onPressed: () {
                              editName(snapshot.data.documents[0]['groupName'], ID);
                            }
                          ): Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Padding(padding: EdgeInsets.only(top: 10),),

              ListTile(
                title: Text(
                    snapshot.data.documents[0]['subCat']+" ("+snapshot.data.documents[0]['category']+")",
                    style: TextStyle(
                      fontFamily: "Comfortaa",
                      letterSpacing: 1.3,
                      fontSize: 18
                    ),
                ),
                leading: Icon(Icons.category, color: Colors.teal,),
              ),

              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Divider(color: Colors.grey,)
              ),

              ListTile(
                leading: Icon(Icons.description, color: Colors.teal,),
                title: Text(
                  snapshot.data.documents[0]['description'],
                  style: TextStyle(
                    fontFamily: "Comfortaa",
                    letterSpacing: 1.3,
                    fontSize: 18
                  ),
                ),
                trailing: showIcon(snapshot, ID, adminID, userID),

              ),

              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(style: BorderStyle.solid, width: 10, color: Colors.black12)),
                  ),
                ),
              ),

              ListTile(
                leading: Icon(Icons.group, color: Colors.teal,),
                title: Text(
                  "$length subcribers",
                  style: TextStyle(
                    fontFamily: "Comfortaa",
                    letterSpacing: 1.3,
                    fontSize: 18
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 30),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(style: BorderStyle.solid, width: 10, color: Colors.black12)),
                  ),
                ),
              ),

              Center(
                child: MaterialButton(
                    color: Colors.red,
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 13),
                    child: new Text(
                      "Exit Group",
                      style: TextStyle(
                          fontFamily: 'Comfortaa',
                          color: Colors.white,
                          letterSpacing: 1.3,
                          fontSize: 17
                      ),
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)
                    ),
                    onPressed: (){
                      removeUserDialog();
                    },
                  ),
              )
            ]
          );
        },
      ),
    );
  }
  showChoiceDailog()
  {
    return showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Text("Select Image source"),
            actions: <Widget>[
              (file != null)?FlatButton(
                child: Text("Remove"),
                onPressed:(){
                  setState(() {
                    file=null;
                  });
                  Navigator.pop(context);
                } ,
              ):FlatButton(),
              FlatButton(
                child: Text("Camera"),
                onPressed: () {
                  getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Gallery"),
                onPressed: (){
                  getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }
  getImage(ImageSource source) async
  {
    var image = await ImagePicker.pickImage(source: source);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    var result = await FlutterImageCompress.compressAndGetFile(
      croppedFile.path, croppedFile.path,
      quality: 90,
    );
    super.setState(() {
      file = result;
    });
  }

  updateImage() {
    print("tap");
  }

  Widget editName(String name, String id) {
    myController.text = name;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: Theme(
            data: new ThemeData(
              fontFamily: "Comfortaa",
            ),
            child: AlertDialog(
              title: Text(
                "Change Group Name: ",
                style: TextStyle(
                  color: Colors.teal,
                  fontFamily: "Comfortaa",
                ),
              ),
              content: TextFormField(
                decoration: InputDecoration(
                  hintText: name,
                ),
                keyboardType: TextInputType.text,
                controller: myController,
                onSaved: (input) => myController.text = input,
                validator: Validation.validateGroupName,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.teal,
                        fontFamily: "Comfortaa",
                        fontSize: 15
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                FlatButton(
                  child: new Text(
                    "Update",
                    style: TextStyle(
                        color: Colors.teal,
                        fontFamily: "Comfortaa",
                        fontSize: 15
                    ),
                  ),
                  onPressed: () async{
                    final formState = _formKey.currentState;
                    if(formState.validate()) {
                      await fireBaseConnection.updateGroupName(id, myController.text);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget showIcon(snapshot, ID, adminID, userID){
    if(adminID == userID) {
      return IconButton(
        icon: Icon(Icons.edit, color: Colors.grey,),
        onPressed: () {
          editDescription(snapshot.data.documents[0]['description'], ID);
        },
      );
    }
  }

  Widget editDescription (String desc, String id){
    myController.text = desc;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: Theme(
              data: new ThemeData(
                fontFamily: "Comfortaa",
              ),
              child: AlertDialog(
                title: Text(
                  "Change Group Description: ",
                  style: TextStyle(
                    color: Colors.teal,
                    fontFamily: "Comfortaa",
                  ),
                ),
                content: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: myController,
                  onSaved: (input) => myController.text = input,
                  validator: Validation.validateDescription,
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.teal,
                          fontFamily: "Comfortaa",
                          fontSize: 15
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  FlatButton(
                    child: new Text(
                      "Update",
                      style: TextStyle(
                          color: Colors.teal,
                          fontFamily: "Comfortaa",
                          fontSize: 15
                      ),
                    ),
                    onPressed: () async{
                      final formState = _formKey.currentState;
                      if(formState.validate()) {
                        await fireBaseConnection.updateDescription(id, myController.text);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget removeUserDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(
            'Exit Group',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: "Comfortaa",
            ),
          ),
          content: Text(
            'Are you sure?',
            style: TextStyle(
              fontFamily: "Comfortaa",
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.teal,
                    fontFamily: "Comfortaa",
                    fontSize: 15
                ),
              )
            ),
            FlatButton(
                onPressed: () async{
                  await fireBaseConnection.deleteUser(groupId);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Home_Page();
                          }));
                },
                child: Text(
                  'Exit',
                  style: TextStyle(
                      color: Colors.teal,
                      fontFamily: "Comfortaa",
                      fontSize: 15
                  ),
                ),
            ),
          ],
        );
      },
    );
  }
}
