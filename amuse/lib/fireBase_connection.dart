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
  User user=new User();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  factory FireBaseConnection()
  {
    return _fireBaseConnection;
  }
  FireBaseConnection._internal();

  Future<FirebaseUser> googleAutoSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser fUser = await _auth.signInWithCredential(credential);
    user.userId=fUser.uid;
    user.eMail=fUser.email;
    user.name=fUser.displayName;
    return fUser;
  }

  Future<void> signOut() async {
    await _auth.signOut().then((_) {
      _googleSignIn.signOut();
    });
  }

  uploadImage(File file) async
  {
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