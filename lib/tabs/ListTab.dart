import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Database/TaskDao.dart';
import 'package:todo_list/MyThemeData.dart';
import 'package:todo_list/providers/AuthProvider.dart';
import 'package:todo_list/providers/SettingProvider.dart';
import 'package:todo_list/tabs/MyTask.dart';

class ListTab extends StatefulWidget {
  late DateTime selectedDate;

  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        backgroundColor: provider.IsDarkEnabled()
          ? MyThemeData.darkprimary
          : MyThemeData.lightSecondry,
      body: Column(
        mainAxisAlignment:MainAxisAlignment.start,
        children: [
          CalendarTimeline(
            locale:"en", // English

            initialDate: selectedDate,
              firstDate: DateTime(2001),
              lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
              onDateSelected: (date) => setState(() => selectedDate = date),
          activeBackgroundDayColor: provider.IsDarkEnabled()
              ?MyThemeData.darksecondry
              :Colors.white ,
          activeDayColor: MyThemeData.lightprimary,
          dotsColor: MyThemeData.lightprimary,
          monthColor:MyThemeData.lightprimary ,
          dayNameColor:  provider.IsDarkEnabled()
              ?Colors.white
              :Colors.black,
              leftMargin: 10,
          ),
          Expanded(
            child: StreamBuilder(
                stream: TaskDao.ListofTasks(authProvider.databaseUser!.id!,selectedDate),
                builder: (context, snapshot) {
                  var taskList = snapshot.data;
                  return ListView.builder(
                      itemCount: taskList?.length,
                      itemBuilder: (context, index) {
                        if (snapshot.connectionState==ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator());
                        }
                        else if (snapshot.hasError){
                          return Center(child: Text('Has Error'));
                        }
                        else{
                          return MyTask(taskList![index]);}
                      });
                }),
          ),
        ],
      ),
    );
  }
}
