import 'package:amuse/LogIn_Page/login.dart';
import 'package:amuse/userClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../categorie.dart';
import '../fireBase_connection.dart';


ListCategories listCategories = new ListCategories();
class SelectCategories extends StatefulWidget {
  @override
  _SelectCategoriesState createState() => _SelectCategoriesState();
}

class _SelectCategoriesState extends State<SelectCategories> {
  FireBaseConnection fireBaseConnection = new FireBaseConnection();

  getUserCategories()async
  {
    User user= new User();
    CollectionReference ref = Firestore.instance.collection('UserInterest');
    QuerySnapshot eventsQuery = await ref
        .where('userId', isEqualTo: user.userId)
        .getDocuments();
    if(eventsQuery.documents.length==0 || eventsQuery.documents.isEmpty)
      return 0;
    eventsQuery.documents.forEach((document)
    {
      listCategories.list.putIfAbsent(document["category"], () => new Category(document["category"].toString(),new List<String>(document["subcat"])));
    });

  }
  @override
  Widget build(BuildContext context) {
    getUserCategories();

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Categories",
          style:  TextStyle(
            fontFamily: 'Comfortaa',
            fontSize: 20.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
            alignment: Alignment.centerRight,
            icon: Icon(Icons.chevron_right),
            onPressed: ()async
            {
              User user=new User();
              await fireBaseConnection.addUserCategories(user.userId, listCategories);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
          )
        ],
      ),
      body: _imageGrid(),
    );
  }

  Widget _imageGrid () {
    return StreamBuilder(
      stream: Firestore.instance.collection('Interested')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return CustomScrollView(
          slivers: <Widget>[
            SliverStaggeredGrid.countBuilder(
              crossAxisCount: 2,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot =
                snapshot.data.documents[index];
                return _gridItem(context,documentSnapshot);
              },
              staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              itemCount: snapshot.data.documents.length,
            ),
          ],
        );
      },
    );
  }

  Widget _gridItem(BuildContext context,DocumentSnapshot snapshot){
    final record = Record.fromSnapshot(snapshot);
    //filterChipWidget wid;
    return Padding(
      //key:ValueKey(record.categories),
      padding: const EdgeInsets.only(top:15.0, left: 0.0, right: 0.0, bottom: 4.0),
      child:FlatButton(
        child: _inkbutton(record),
        onPressed:(()=>
            showDialog(
              context: context,
              builder: (BuildContext context) => new ShowDialogWidget(record: record),
            )
            //new ShowDialogWidget(record: record)
        ),
      ),
    );
  }

  Widget _inkbutton(Record record){
    return  new Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.teal[100],
      ),
      height: 80.0,
      width: double.infinity,
      child: _category(record),
    );

  }
  Widget _category(Record record){
    return new Container(
      alignment: Alignment.center,
      child: SizedBox(
          width:150.0,
          child:new Text(record.categories,
            textAlign: TextAlign.center,
            style:  TextStyle(
              fontFamily: 'Comfortaa',
              fontWeight: FontWeight.w700,
              fontSize: 20.0,
            ),
          )
      ),
    );
  }
}
class Record {
  final int index;
  final String categories;
  final String images;
  final List<dynamic> subCat;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['categories'] != null),
  // assert(map['images'] != null),
        categories = map['categories'],
        images = map['images'],
        index=map['index'],
        subCat= map['subCat'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$categories:$images>";
}

class ShowDialogWidget extends StatefulWidget{
  final Record record;
  ShowDialogWidget({Key key,@required this.record}):super(key:key);
  @override
  State<StatefulWidget> createState() => ShowDialogState(record);
}
class ShowDialogState extends State<ShowDialogWidget>{
  Record record;
  String chipName;
  List<dynamic> subList;
  List<String> temp = new List<String>();

  ShowDialogState(Record record){
    this.record=record;
    chipName=record.categories;
    subList=record.subCat;
  }
  @override
  Widget build(BuildContext context) {
    return _buildAboutDialog(context,record);
  }
  Widget _buildAboutDialog(BuildContext context,Record record) {
    return new AlertDialog(
      title: Text(record.categories,
          style:  TextStyle(
            fontFamily: 'Comfortaa',
            fontWeight: FontWeight.w700,
            fontSize: 20.0,
          )
      ),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Wrap(
              spacing:5.0,
              runSpacing:5.0,
              children:<Widget>[
                _filterChip(record),
              ]
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            print(temp);
            if(listCategories.list[record.categories.toString()] != null)
              {
                listCategories.list[record.categories.toString()].subCat.clear();
                listCategories.list[record.categories.toString()].subCat.addAll(temp.toList());

              }
            else
              {
                Category c= new Category(record.categories.toString(), temp.toList());
                listCategories.list.putIfAbsent(record.categories.toString(), () => c);
              }

            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Save',
            style: TextStyle(
              fontFamily: 'Comfortaa',
              // backgroundColor:Colors.blue,
              //color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
  Widget _filterChip(Record record){
    List<Widget> lists =new List<Widget>();
    for(var i=0;i < record.subCat.length;i++){
      lists.add(chips(subList[i]));
    }
    return Column(children: lists);
  }
  Widget chips(var chip){
    if(listCategories.list[record.categories.toString()] != null)
    temp.addAll(listCategories.list[record.categories.toString()]?.subCat);
    return new FilterChip(
      backgroundColor: Colors.grey[100],
      label:Text(chip),
      selected: (temp.contains(chip))?true:false,//selected.contains(chip)?true:false,
      labelStyle: TextStyle(color:Colors.teal,fontSize: 16.0,fontFamily: 'Comfortaa'),
      onSelected: (isSelected){
        setState(() {
          if(isSelected)
            {
                temp.add(chip);
            }
          else
            {
                temp.remove(chip);
            }
        });
      },
      selectedColor: Colors.teal[50],
    );
  }
}
