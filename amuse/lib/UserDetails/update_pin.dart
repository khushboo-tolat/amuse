import 'package:flutter/material.dart';
import '../themeFile.dart';
import '../userClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group/Validation/validationClass.dart';
import '../fireBase_connection.dart';

class update_pin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => update_pinState();
}

class update_pinState extends State<update_pin> {
  FireBaseConnection fireBaseConnection = new FireBaseConnection();
  User user = new User();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final pin1=new TextEditingController();
  final pin2=new TextEditingController();
  var id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('User').where('userId', isEqualTo: user.userId).snapshots(),
      builder: (context, snapshot){
        id = snapshot.data.documents[0].documentID;

        String oldPin, newPin;

        if(!snapshot.hasData)
          return Text("Group data not found....");

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Change Pin',
              style: TextStyle(
                fontSize: 23,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: IconButton(
                  icon: Icon(Icons.check, size: 30,),
                  onPressed: (){
                    _formKey.currentState.validate();
                    _formKey.currentState.save();
                    editPin(oldPin, newPin, id);
                  },
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
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 20),),
                  Container(
                    alignment: AlignmentDirectional.topCenter,
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child:Form(
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
                                labelText: "Old Pin",
                                labelStyle: TextStyle(
                                  color: Colors.teal,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              onSaved: (input) => oldPin = input,
                            ),

                            new TextFormField(
                              decoration: InputDecoration(
                                labelText: "New Pin",
                                labelStyle: TextStyle(
                                  color: Colors.teal,
                                ),
                              ),
                              controller: pin1,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              onSaved: (input) => newPin = input,
                              validator: validation.validatePIN,
                            ),

                            new TextFormField(
                              decoration: InputDecoration(
                                labelText: "Confirm Pin",
                                labelStyle: TextStyle(
                                  color: Colors.teal,
                                ),
                              ),
                              controller: pin2,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (value) {
                                if (value != pin1.text) {
                                  return 'PIN is not matching';
                                }
                              },
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
      },
    );
  }

  Future<Widget> editPin(String oldPin, String newPin, String id) async{
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        if(await fireBaseConnection.checkOldPin(oldPin) == true){
          fireBaseConnection.updatePin(newPin, id);
          Navigator.pop(context);
        }
        else{
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Enter correct old pin',
                  style: TextStyle(
                    fontFamily: "Comfortaa",
                  ),
                ),

                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                          color: Colors.teal,
                          fontFamily: "Comfortaa",
                          fontSize: 15
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        }
      }
      catch (e) {
        print(e.message);
      }
    }
  }


}