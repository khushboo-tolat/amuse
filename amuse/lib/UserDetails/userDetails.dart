import 'dart:io';

import 'package:amuse/LogIn_Page/login.dart';
import 'package:amuse/Select_Categories/select_categories.dart';
import 'package:amuse/Validation/validationClass.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../fireBase_connection.dart';
import '../themeFile.dart';
import '../userClass.dart';
class AddProfileDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddProfileDetailsState();
}

class AddProfileDetailsState extends State<AddProfileDetails> {
  User user = new User();
  FireBaseConnection fireBaseConnection= new FireBaseConnection();
  File file =null;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final pwd1=new TextEditingController();
  final pwd2=new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("amuse"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(Icons.check, size: 30,),
              onPressed: () async {
                if(_formKey.currentState.validate())
                  {
                    if(pwd1.text == pwd2.text)
                    {
                      _formKey.currentState.validate();
                      _formKey.currentState.save();
//                    await fireBaseConnection.signOut();
//                    await fireBaseConnection.signUpWithEmail(user.eMail, pwd1.text);
                      if(file != null)
                      {
                        await fireBaseConnection.uploadImage(file);
                      }
                      await fireBaseConnection.addUserDetails(user, pwd1.text);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectCategories()));
                    }
                  }

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
                //Padding(padding: EdgeInsets.only(top: 1),),
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: <Widget>[
                    Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: (file==null) ? AssetImage(
                                "assets/images/user_default.png") : FileImage(file),
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
                          onPressed: showChoiceDailog,
                      ),
                    ),
                  ],
                ),

                Container(
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
                            initialValue: user.name,
                            onSaved: (input) => user.name = input,
                            decoration: InputDecoration(
                              labelText: "Name",
                            ),
                            keyboardType: TextInputType.text,
                            validator: Validation.validateUsername,
                          ),

                          Padding(padding: EdgeInsets.only(top: 15),),

                          new TextFormField(
                            decoration: InputDecoration(
                              labelText: "Email Id",
                            ),
                            initialValue: user.eMail,
                            enabled: false,
                          ),

                          Padding(padding: EdgeInsets.only(top: 15),),

                          new TextFormField(
                            validator: (value){
                              return Validation.validatePIN(value);
                            },
                            controller: pwd1,
                            decoration: InputDecoration(
                              labelText: "Enter PIN",
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                          ),

                          Padding(padding: EdgeInsets.only(top: 15),),

                          new TextFormField(
                            controller: pwd2,
                            decoration: InputDecoration(
                              labelText: "Comfirm PIN",
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            validator: (value) {
                              if (value != pwd1.text) {
                              return 'PIN is not matching';
                              }
                             },
                          ),

                          //Padding(padding: EdgeInsets.only(top: 1),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
}
