import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:amuse/userClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'categorie.dart';

class FireBaseConnection
{
  static final FireBaseConnection _fireBaseConnection=new FireBaseConnection._internal();
  var currentUserEmail;
  User user=new User();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  factory FireBaseConnection()
  {
    return _fireBaseConnection;
  }
  FireBaseConnection._internal();

  Future<AuthResult> googleAutoSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final AuthResult fUser = await _auth.signInWithCredential(credential);
    user.userId=fUser.user.uid;
    user.eMail=fUser.user.email;
    user.name=fUser.user.displayName;
    return fUser;
  }

  Future<void> signOut() async {
    await _auth.signOut().then((_) {
      _googleSignIn.signOut();
    });
  }
  Future<String> uploadImage(File file,String Id, bool temp) async
  {
    if(temp)
      {
        if(file.lengthSync()!= 0)
        {
          User user = new User();
          StorageReference reference=FirebaseStorage.instance.ref().child(
              'ProfilePecture/'+Id+".jpg");
          StorageUploadTask uploadTask = reference.putFile(file);
          StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
          return taskSnapshot.ref.getDownloadURL().toString();
        }
      }
    else
      {
        if(file.lengthSync()!= 0)
        {
          User user = new User();
          StorageReference reference=FirebaseStorage.instance.ref().child(
              'GroupPic/'+Id+".jpg");
          StorageUploadTask uploadTask = reference.putFile(file);
          StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
          return taskSnapshot.ref.getDownloadURL().toString();
        }
      }
  }

  addUserDetails(User user, String pin) async
  {
    Map<String,String> maped;
    if(user.profilePicture != null)
    {
        maped = {
          'userId' : user.userId,
          'email' : user.eMail,
          'userName' : user.name,
          'profilePictureLink' : user.profilePicture,
          'pin' : pin
        };
    }
    else
    {
      maped = {
        'userId' : user.userId,
        'email' : user.eMail,
        'userName' : user.name,
        'pin' : pin
      };

    }
    Firestore.instance.runTransaction((Transaction addDetails)async
    {
      await Firestore.instance.collection("User").add(maped).catchError((e)
      {
        print(e);
      });
    });
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  Future<bool> checkUserIsAlreadyRegistered(userId)async
  {
    return (await Firestore.instance.collection('User')
        .where('userId', isEqualTo: userId).limit(1)
        .getDocuments()
        .then((user){
          if(user.documents.length == 1)
            {
              return true;
            }
          else
            {
              return false;
            }
    }));
  }
  ensureLoggedIn() async {
    GoogleSignInAccount signedInUser = _googleSignIn.currentUser;
    if (signedInUser == null)
      signedInUser = await _googleSignIn.signInSilently();
    if (signedInUser == null) {
      await _googleSignIn.signIn();
    }
    currentUserEmail = _googleSignIn.currentUser.email;
    if (await _auth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
          await _googleSignIn.currentUser.authentication;
      // await auth.signInWithGoogle(
      //     idToken: credentials.idToken, accessToken: credentials.accessToken);
    }
  }
  Future<List<String>> getGroup(String id)async
  {
    List<String> temp = new List<String>();
    QuerySnapshot doc= await Firestore.instance.collection('Group').where('groupId', isEqualTo: id).getDocuments();
    temp.add(doc.documents[0]['groupName'].toString());
    temp.add(doc.documents[0]['groupPic'].toString());
    return temp;
  }

  addGroupDetails(groupData) async{
    await Firestore.instance
        .collection("Group")
        .add(groupData)
        .catchError((e){
          print(e);
        });
  }

  updateUserName(name) async{
    var doc = await Firestore.instance.collection('User').where('userId', isEqualTo: user.userId).getDocuments();

    await doc.documents.forEach((doc) =>{
      doc.reference.updateData({'userName': name}),
    });
  }
  updateGroupPic(String url, String groupId) async{
    var doc = await Firestore.instance.collection('Group').where('groupId', isEqualTo: groupId).getDocuments();

    await doc.documents.forEach((doc) =>{
      doc.reference.updateData({'groupPic': url}),
    });
  }
  deleteGroupPic(String groupId) async{
    var doc = await Firestore.instance.collection('Group').where('groupId', isEqualTo: groupId).getDocuments();

    await doc.documents.forEach((doc) =>{
      doc.reference.updateData({'groupPic': null}),
    });
    StorageReference desert_ref = FirebaseStorage().ref().child("GroupPic/"+groupId+".jpg");
    desert_ref.delete();
  }
  deleteProfilePic(String userId) async{
    var doc = await Firestore.instance.collection('User').where('userId', isEqualTo: userId).getDocuments();

    await doc.documents.forEach((doc) =>{
      doc.reference.updateData({'profilePictureLink': null}),
    });
    StorageReference desert_ref = FirebaseStorage().ref().child("ProfilePecture/"+userId+".jpg");
    desert_ref.delete();
  }

  updatePin(newPin, id) async{
    await Firestore.instance.collection('User').document(id).updateData({'pin': newPin}).catchError((x) {
      print(x);
    });
  }

  Future<bool> checkOldPin(String oldPin) async{
    return (
        await Firestore.instance.collection('User')
            .where('userId', isEqualTo: user.userId)
            .where('pin', isEqualTo: oldPin)
            .getDocuments()
            .then((user){
          if(user.documents.length == 1)
          {
            return true;
          }
          else
          {
            return false;
          }
        })
    );
  }

  Future countMembers(groupId) async {
    var respectsQuery = Firestore.instance
        .collection('GroupMember')
        .where('groupId', isEqualTo: groupId);
    var querySnapshot = await respectsQuery.getDocuments();
    var total = querySnapshot.documents.length;
    return total;
  }

  updateGroupName(id, name) async{
    await Firestore.instance
        .collection('Group')
        .document(id)
        .updateData({'groupName': name})
        .catchError((x) {
      print(x);
    });
  }

  updateDescription(id, name) async{
    await Firestore.instance
        .collection('Group')
        .document(id)
        .updateData({'description': name})
        .catchError((x) {
      print(x);
    });
  }

  deleteUser(groupId) async{
    var doc = await Firestore.instance
        .collection('GroupMember')
        .where('groupId', isEqualTo: groupId)
        .where('userId', isEqualTo: user.userId)
        .getDocuments();

    await doc.documents.forEach((doc) => {
      doc.reference.delete(),
    });

    var doc2 = await Firestore.instance
        .collection('UserGroups')
        .where('groupId', isEqualTo: groupId)
        .where('userId', isEqualTo: user.userId)
        .getDocuments();

    await doc2.documents.forEach((doc2) => {
      doc2.reference.delete(),
    });
  }

  offlineUser(groupId) async{
    var doc = await Firestore.instance
        .collection('UserGroups')
        .where('groupId', isEqualTo: groupId)
        .where('userId', isEqualTo: user.userId)
        .getDocuments();

    await doc.documents.forEach((doc) => {
      doc.reference.updateData({'mode': false}),
    });
  }
  Future<bool> addUserCategories(String userId, ListCategories list)
  {
    CollectionReference ref = Firestore.instance.collection('UserInterest');
    list.list.entries.forEach(
            (value)
            {
              Map<String,dynamic> maped ={
                'userId' : userId,
                'categories' : value.value.mainCat.toString(),
                'subCats' : value.value.subCat.toList()
              };
              ref.add(maped);
            });

  }


}