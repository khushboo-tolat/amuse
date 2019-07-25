import 'package:flutter/material.dart';
import '../themeFile.dart';
import '../userClass.dart';
import 'package:group/Validation/validationClass.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../fireBase_connection.dart';

class update_profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => update_profileState();
}

class update_profileState extends State<update_profile> {
  FireBaseConnection fireBaseConnection = new FireBaseConnection();
  User user = new User();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File file = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(Icons.check, size: 30,),
              onPressed: () {update();},
            ),
          ),
        ],
      ),

      body: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 70),),
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
                          decoration: InputDecoration(
                            labelText: "Name",
                          ),
                          keyboardType: TextInputType.text,
                          initialValue: user.name,
                          validator: validation.validateUsername,
                          onSaved: (input) => user.name = input,
                        ),

                        Padding(padding: EdgeInsets.only(top: 15),),

                        new TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email Id",
                          ),
                          initialValue: user.eMail,
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> update() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      if(file != null)
      {
        await uploadImage(file);
      }
      await fireBaseConnection.updateUserName(user.name);
      Navigator.pop(context);
    }
  }

  uploadImage(File file) async {
    if(file.lengthSync()!= 0)
    {
      User user = new User();
      StorageReference reference=FirebaseStorage.instance.ref().child(
          'ProfilePecture/'+user.userId+".jpg");
      StorageUploadTask uploadTask = reference.putFile(file);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      user.profilePicture= taskSnapshot.ref.getDownloadURL().toString();
    }
  }

  getImage(ImageSource source) async {
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

  showChoiceDailog() {
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