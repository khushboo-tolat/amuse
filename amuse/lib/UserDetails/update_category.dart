import 'package:flutter/material.dart';

class update_category extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => update_categoryState();
}

class update_categoryState extends State<update_category>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(Icons.check, size: 30,),
              onPressed: (){},
            ),

          ),
        ],
      ),

      body: Container(
        child: Text("Update Category"),
      ),
    );
  }
}