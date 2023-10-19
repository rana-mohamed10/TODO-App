import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/Database/UserDao.dart';
import 'package:todo_list/Database/model/Task.dart';

class TaskDao {
    static CollectionReference<Task>getTasksCollection(String uid){
        //to create a task for each user
        return UserDao.getUsersCollection()
        .doc(uid)
        .collection(Task.collectionName)
        .withConverter(
            fromFirestore: (snapshot, options) => Task.fromFireStore(snapshot.data()),
            toFirestore: (task, options) => task.toFireStore() ,);
    }
    static Future<void> createTask(Task task,String uid){
        var docRef= getTasksCollection(uid)
            .doc();
        task.id=docRef.id;
        return docRef.set(task);
    }

    static Stream<List<Task>> ListofTasks(String uid,DateTime time) async*{
        DateTime startTime=DateTime(time.year,time.month,time.day);
        DateTime endTime=DateTime(time.year,time.month,time.day,23,59,59);
        var userTasks = getTasksCollection(uid)
        .where("datetime",isGreaterThanOrEqualTo: startTime)
        .where("datetime",isLessThanOrEqualTo: endTime)
        .snapshots();
        yield* userTasks.map((snapshots) => snapshots.docs.map((e) => e.data()).toList());
    }



}