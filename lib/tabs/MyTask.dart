import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Database/model/Task.dart';
import 'package:todo_list/DialogUtilits.dart';
import 'package:todo_list/HomeScreen/TaskBottomSheet.dart';
import 'package:todo_list/MyThemeData.dart';
import 'package:todo_list/providers/AuthProvider.dart';
import 'package:todo_list/providers/SettingProvider.dart';

class MyTask extends StatefulWidget{
  Task task;
  MyTask(this.task);

  @override
  State<MyTask> createState() => _MyTaskState();
}

class _MyTaskState extends State<MyTask> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: provider.IsDarkEnabled()
              ?MyThemeData.darksecondry
              :Colors.white,
        ),
        child: Slidable(
          startActionPane: ActionPane(
              motion: DrawerMotion(),
              children:[
                SlidableAction(
                onPressed: (context) {
                  setState(() {
                    deleteFunc();
                  });
                },
                backgroundColor: Colors.red,
                icon: Icons.delete,
                label: 'delete',
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18), bottomLeft: Radius.circular(18)),
                padding: const EdgeInsets.all(12),
              ),
                SlidableAction(
                  onPressed: (context) {
                    setState(()  {
                      showEditTask(widget.task);
                    });
                  },
                  backgroundColor: Colors.grey,
                  icon: Icons.edit_note,
                  label: 'edit',
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),] ,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: widget.task.isDone==false?
                Image.asset('assets/images/Rectangle22.png')
                :Image.asset('assets/images/Rectangle_g.png'),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.task?.title}',
                      style: TextStyle(
                          color:widget.task.isDone==false
                              ?MyThemeData.lightprimary
                              :Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${widget.task?.description}',
                      style: TextStyle(
                        color:  provider.IsDarkEnabled()
                          ?Colors.white
                          :Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.task.isDone?Text('Done!',style: TextStyle(
                    color: Colors.green,fontSize: 22),):
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color:
                    Theme.of(context).colorScheme.primary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 11.0, right: 11.0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          widget.task.isDone=true;
                        });
                      },
                      icon: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void deleteFunc() {
    DialogUtilits.ShowMessage(context, 'Are you sure you want to delete this task?',
    posActionTitle: "Yes",
      posAction: (){
      deleting();
      },
      negActionTitle: 'NO'
    );

  }

  void showEditTask(Task task) {
    showModalBottomSheet(context: context,
        builder: (BuildContext){
      return TaskBottomSheet(task: task,edit: true);
    });
  }

  void deleting() {
    var provider=Provider.of<AuthProvider>(context,listen: false);
    provider.deleting(widget.task, provider.databaseUser!.id!);
  }
}