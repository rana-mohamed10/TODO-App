import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Database/TaskDao.dart';
import 'package:todo_list/Database/UserDao.dart';
import 'package:todo_list/Database/model/Task.dart';

import 'package:todo_list/Database/model/User.dart' as MyUser;
import 'package:todo_list/DialogUtilits.dart';
import 'package:todo_list/Login/LoginScreen.dart';
class AuthProvider extends ChangeNotifier{
  User? authFirebaseUser;
  MyUser.User? databaseUser ;

   Future<void> Register(String email,String password,String fullName,
       String userName) async{
    var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email,
        password: password);
    await UserDao.CreateUser(
        MyUser.User(
          id:result.user?.uid ,
          userName: userName,
          fullName:fullName ,
          email: email,
        ));
  }

  Future<void> Login (String email,String password)async{
    final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password);
    var user=await UserDao.getUser(result.user!.uid);
    databaseUser=user;
    authFirebaseUser=result.user;
  }

  bool isUserLoggedInBefore(){
     return FirebaseAuth.instance.currentUser!=null;
  }

  Future <void> retrieveUserFromDatabase() async{
    authFirebaseUser =FirebaseAuth.instance.currentUser;
    databaseUser = await UserDao.getUser(authFirebaseUser!.uid);
  }

  void logout(context){
    var authProvider=Provider.of<AuthProvider>(context,listen: false);
    DialogUtilits.ShowMessage(context, 'Are you sure you want to Exit?',
        posActionTitle: 'Yes',
        posAction: (){
          authProvider.logout;
          Navigator.of(context).pushNamed(LoginScreen.routeName);
        },
        negActionTitle: 'NO');
  }
   Future <void> deleting(Task task,String uid)async{
     var taskCollect=TaskDao.getTasksCollection(uid);
     await taskCollect.doc(task.id).delete();
  }
  Future <void> editing(Task? task,String uid)async{
    var taskCollect=TaskDao.getTasksCollection(uid);
    await taskCollect.doc(task?.id).update({
      'title' : task?.title,
      'description' : task?.description,
      'datetime' : task?.datetime,
      'isDone' : task?.isDone
    });
    notifyListeners();
    return;
  }

  //Setting Provider



}