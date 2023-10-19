import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/HomeScreen/TaskBottomSheet.dart';
import 'package:todo_list/MyThemeData.dart';
import 'package:todo_list/providers/AuthProvider.dart';
import 'package:todo_list/providers/SettingProvider.dart';
import 'package:todo_list/tabs/ListTab.dart';
import 'package:todo_list/Settings/SettingsTab.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "Home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    var authProvider=Provider.of<AuthProvider>(context);
    var settingProvider=Provider.of<SettingProvider>(context);


    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          leading: IconButton(onPressed: () {
            authProvider.logout(context);
          },
              icon: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Icon(Icons.logout_outlined),
              )),
          title: Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Text('To Do List'),
          ),
          backgroundColor: MyThemeData.lightprimary,
        ),
      ),
      backgroundColor: settingProvider.IsDarkEnabled()
          ? MyThemeData.darkprimary
          : MyThemeData.lightSecondry,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(
          side: BorderSide(
            color: Colors.white,
            width: 4
          )
        ),
        onPressed: (){
        ShowBottomSheet();
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar:BottomAppBar(
   color: settingProvider.IsDarkEnabled()?MyThemeData.darksecondry:Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 12, //space between the button and bottomNavBar
        child:
        BottomNavigationBar(
          onTap: (index) {
            setState(() {
              selectedTabIndex = index;
            });
          },
          currentIndex: selectedTabIndex,
          backgroundColor: Colors.transparent,
           elevation: 0, //for the shadow
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
              label: ""
          ),
        ],
      ),
      ),
      body:tabs[selectedTabIndex] ,
    );
  }
  var tabs = [ListTab(), SettingsTab()];


  void ShowBottomSheet() {

    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28)
      ),

      context: context,
      builder: (context)
      {
        return TaskBottomSheet(edit: false,);
      },
    );
  }


  }


