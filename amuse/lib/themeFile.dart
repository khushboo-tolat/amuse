import 'package:flutter/material.dart';

class ThemeFile
{
  static InputDecorationTheme inputDecorationTheme = new InputDecorationTheme(
    hintStyle: new TextStyle(
      letterSpacing: 1.5,
      fontSize: 10,
      fontFamily: 'Comfortaa',
    ),

    labelStyle: new TextStyle(
      color: Colors.teal,
      fontSize: 17,
      letterSpacing: 1.5,
      fontFamily: 'Comfortaa',
    )
  );

  static ThemeData themeData = new ThemeData(
    appBarTheme: new AppBarTheme(
      color: Colors.teal,
      textTheme: new TextTheme(
        title: TextStyle(
          fontFamily: "Comfortaa",
          fontSize: 30,
          color: Colors.white,
        )
      ),
    ),

    textTheme: new TextTheme(
      title: TextStyle(
        fontFamily: "Comfortaa",
      ),
    ),

    primarySwatch: Colors.teal,

    primaryTextTheme: new TextTheme(
      title: TextStyle(
        fontFamily: "Comfortaa",
      ),

      subtitle: TextStyle(
        fontFamily: "Comfortaa",
      )
    )


  );
}