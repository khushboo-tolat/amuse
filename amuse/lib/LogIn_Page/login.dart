import 'package:amuse/UserDetails/userDetails.dart';
import 'package:amuse/Validation/validationClass.dart';
import 'package:flutter/material.dart';
import '../fireBase_connection.dart';
import '../themeFile.dart';
import '../userClass.dart';

class LoginPage extends StatefulWidget{
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{
  FireBaseConnection fireBaseConnection = new FireBaseConnection();
  final eMail = TextEditingController();
  final password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    if(fireBaseConnection.getUser()!= null)
//      {
//        Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//                builder: (context) => MyHomePage()));
//      }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image(
                image: AssetImage("assets/images/map.jpg"),
                fit: BoxFit.cover,
                color: Colors.black87,
                colorBlendMode: BlendMode.darken,
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: Image(
                      image: AssetImage('assets/images/logo_white_transparent.png'),
                    ),
                  ),
                  new Form(
                    child: Theme(
                      data: new ThemeData(
                        brightness: Brightness.dark,
                        inputDecorationTheme: ThemeFile.inputDecorationTheme,
                      ),
                      child: Container(
                        padding: new EdgeInsets.all(60),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new MaterialButton(
                                color: Color.fromRGBO(211, 211, 211, 1),
                                child: new Row(
                                  children: <Widget>[
                                    new Image.asset(
                                      'assets/images/google_logo.png',
                                      height: 48.0,
                                      width: 50.0,
                                    ),
                                    new Text('  Sign in with Google', style: TextStyle(color: Colors.black54, letterSpacing: 1.3, fontSize: 17)),
                                  ],
                                ),
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(20.0)
                                ),
                                onPressed: () async {
                                  if(await fireBaseConnection.googleAutoSignIn() != null)
                                  {
                                    User user=new User();
                                    if(await fireBaseConnection.checkUserIsAlreadyRegistered(user.userId)== true)
                                    {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyHomePage()));

                                    }
                                    else
                                    {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddProfileDetails()));

                                    }

                                    //print(user.name+"       "+user.eMail+"     "+user.userId);
                                  }
                                  else
                                  {
//                                  showDialog(context: context,builder: );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User user =new User();
  FireBaseConnection fireBaseConnection=new FireBaseConnection();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.userId+"  "+user.eMail),
      ),
      body: RaisedButton(
          child: Text("Signout"),
          onPressed: () async {
            await fireBaseConnection.signOut();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage()));
          }
          ),

    );
  }
}
