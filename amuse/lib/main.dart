import 'package:amuse/userClass.dart';
import 'package:flutter/material.dart';

import 'LogIn_Page/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  User user=new User();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        appBarTheme: AppBarTheme(
            color: Colors.teal,
            textTheme: TextTheme(
                title: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontFamily: 'Comfortaa',)
            )
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

