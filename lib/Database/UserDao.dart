import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/User.dart';

class UserDao{

  static CollectionReference <User> getUsersCollection(){
//insert into FireStore
    var db = FirebaseFirestore.instance;
    var userCollection= db.collection(User.collectionName)
        .withConverter(
      fromFirestore:(snapshot, options) => User.fromFireStore(snapshot.data()),
      toFirestore:(object, options) => object.toFireStore() , );
    return userCollection;
  }
  static Future<void> CreateUser (User user){
    var usersCollection = getUsersCollection();
    //create user id the same as Authentication service
    var doc=usersCollection.doc(user.id);
    // change data of doc 
    return doc.set(user);
  }

  static Future<User?> getUser(String uid) async{
     var doc = getUsersCollection()
          .doc(uid);
     var docSnapshot= await doc.get();
     return docSnapshot.data();
  }
}