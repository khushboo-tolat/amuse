import 'dart:io';

import 'package:amuse/Location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../themeFile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../fireBase_connection.dart';
import 'groupClass.dart';
import '../userClass.dart';
import '../Validation/validationClass.dart';

class CreateGroup extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => CreateGroupState();
}

class CreateGroupState extends State<CreateGroup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FireBaseConnection fireBaseConnection= new FireBaseConnection();
  User user = new User();
  Group group = new Group();
  var sliderValue = 5.0;
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Group', style: TextStyle(fontSize: 20),),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(Icons.check, size: 30,),
              onPressed: () async{
                final formState = _formKey.currentState;
                if (formState.validate()) {
                  formState.save();
                  Map<String,dynamic> map;
                  String url;

                  if(group.category != null && group.subCat != null){
                    String groupId = user.userId + DateTime.now().toString();
                    if(file != null)
                    {
                      url = await fireBaseConnection.uploadImage(file,groupId,false);
                    }
                    Position p =Location.getLocation();
                    map = {
                      'groupPicture' : url,
                      'groupId' : groupId,
                      'groupName' : group.groupName,
                      'createdBy' : user.userId,
                      'area' : sliderValue.toString(),
                      'category' : group.category,
                      'subCat' : group.subCat,
                      'description' : group.desc,
                      'dateTime' : DateTime.now().toString(),
                      'geoPoint' : new GeoPoint(p.latitude, p.longitude)
                    };

                    await fireBaseConnection.addGroupDetails(map);
                  }
                  else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context)
                      {
                        return AlertDialog(
                          title: Text("Select Category/Sub-Category"),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                }, 
                                child: Text('OK'),
                            )
                          ],
                        );
                      }
                    );
                  }
                }
                /*Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                  )
                );*/
              },
            ),
          ),
        ],
      ),

      body: Center(
        child: GestureDetector(
          //behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                displayImage(),
                displayForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displayImage(){
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: <Widget>[
        Container(
          width: 140.0,
          height: 140.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: (file != null)?FileImage(file):AssetImage('assets/images/group_default.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(80)
          ),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: showChoiceDailog
          ),
        ),
      ],
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

  Widget displayForm(){
    return Container(
      padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
      child: Form(
        key: _formKey,
        child: Theme(
          data: new ThemeData(
              inputDecorationTheme: ThemeFile.inputDecorationTheme,
              primarySwatch: Colors.teal
          ),
          child: Column(
            children: <Widget>[
              new TextFormField(
                onSaved: (input) => group.groupName = input,
                decoration: InputDecoration(
                  labelText: "Group Name",
                ),
                keyboardType: TextInputType.text,
                validator: Validation.validateGroupName,
              ),

              Padding(padding: EdgeInsets.only(top: 15),),

              Row(
                children: <Widget>[
                  Text("Select Category: ", style: TextStyle(fontSize: 18, fontFamily: "Comfortaa", color: Colors.teal,),),

                  Padding(padding: EdgeInsets.only(right: 50),),

                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('Interested').snapshots(),
                    builder: (context, snapshot){
                      if(!snapshot.hasData){
                        Text("Loading");
                      }
                      return SizedBox(
                        width: 150,
                        child: DropdownButton(
                          value: group.category,
                          items: snapshot.data.documents.map((DocumentSnapshot document){
                            return DropdownMenuItem(
                                value: document.data["categories"],
                                child: new Text(document.data["categories"]));
                          }).toList(),
                          onChanged: (value){
                            setState((){
                              group.category = value;
                            });
                          },
                          isExpanded: true,
                          hint: Text("Select Category"),
                          style: TextStyle(fontFamily: "Comfortaa", color: Colors.black87),
                        ),
                      );
                    },
                  ),
                ],
              ),

              Padding(padding: EdgeInsets.only(top: 5),),

              Row(
                children: <Widget>[
                  Text("Select Sub-Category: ", style: TextStyle(fontSize: 18, fontFamily: "Comfortaa", color: Colors.teal,),),

                  Padding(padding: EdgeInsets.only(right: 10),),

                  displaySubCat(group.category),
                ],
              ),

              Padding(padding: EdgeInsets.only(top: 15),),

              displaySlider(),

              TextFormField(
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Group Description",
                ),
                keyboardType: TextInputType.text,
                validator: Validation.validateDescription,
                onSaved: (input) => group.desc = input,
              ),

              Padding(padding: EdgeInsets.only(top: 15),),
            ],
          ),
        ),
      ),
    );
  }

  Widget displaySubCat(setCategory){
    List<dynamic> temp;

    if(setCategory != null){
      return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Interested').where('categories', isEqualTo: setCategory).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              Text("Loading");
            }
            else {
              temp = snapshot.data.documents[0]['subCat'].toList();

              return SizedBox(
                width: 150,
                child: DropdownButton(
                  value: group.subCat,
                  items: temp.map((dynamic document) {
                    return DropdownMenuItem(
                        value: document,
                        child: new Text(document.toString())
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      group.subCat = value;
                    });
                  },
                  isExpanded: true,
                  hint: Text("Select Sub-Cat"),
                  style: TextStyle(
                      fontFamily: "Comfortaa", color: Colors.black87),
                ),
              );
            }

            return Text('');
          }
      );
    }
    else{
      return SizedBox(
          width: 150,
          child: DropdownButton(
            isExpanded: true,
            hint: Text("Select Sub-Cat"),
            style: TextStyle(fontFamily: "Comfortaa", color: Colors.black87),
          )
      );
    }
  }

  Widget displaySlider(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Set Visibility of Group: ", style: TextStyle(fontSize: 18, fontFamily: "Comfortaa", color: Colors.teal,),),
            Padding(padding: EdgeInsets.only(right: 50),),
            Text("${sliderValue}", style: TextStyle(fontSize: 18, fontFamily: "Comfortaa")),
            Text(" KM", style: TextStyle(fontSize: 18, fontFamily: "Comfortaa")),
          ],
        ),

        Container(
          child: SizedBox(
            height: 60,
            child: Slider(
              min: 5.0,
              max: 30.0,
              divisions: 5,
              value: sliderValue,
              activeColor: Colors.teal,
              onChanged: (value){
                setState(() {
                  sliderValue = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

