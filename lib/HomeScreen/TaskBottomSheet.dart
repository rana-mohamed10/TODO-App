import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/CustomFormFeild.dart';
import 'package:todo_list/Database/TaskDao.dart';
import 'package:todo_list/Database/model/Task.dart';
import 'package:todo_list/DialogUtilits.dart';
import 'package:todo_list/MyThemeData.dart';
import 'package:todo_list/providers/AuthProvider.dart';
import 'package:todo_list/providers/SettingProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class TaskBottomSheet extends StatefulWidget {
  Task? task;
  bool edit;
  TaskBottomSheet({this.task, required this.edit});
  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  TextEditingController TaskController = TextEditingController();

  TextEditingController DsecController = TextEditingController();

  var FormKey = GlobalKey<FormState>();

  DateTime? selectedDate;

  bool isSelected = false;
  bool isSelected1 = false;

  @override
  Widget build(BuildContext context) {
    var settingProvider = Provider.of<SettingProvider>(context);
    return Container(
      color: settingProvider.IsDarkEnabled()
          ? MyThemeData.darkprimary
          : MyThemeData.lightSecondry,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Text(
                'Add New Task',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: settingProvider.IsDarkEnabled()
                        ? Colors.white
                        : MyThemeData.darkprimary),
              ),
            ),
          ),
          Form(
            key: FormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                  child: CustomFormFeild(
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'please enter Task Title';
                      }
                      return null;
                    },
                    controller: TaskController,
                    hint: AppLocalizations.of(context)!.task_title,
                    labelStyle: settingProvider.IsDarkEnabled()
                        ? Colors.white
                        : MyThemeData.darkprimary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                  child: CustomFormFeild(
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'please enter Task Description';
                      }
                      return null;
                    },
                    controller: DsecController,
                    hint:  AppLocalizations.of(context)!.task_description,
                    labelStyle: settingProvider.IsDarkEnabled()
                        ? Colors.white
                        : MyThemeData.darkprimary,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                  child: InkWell(
                    onTap: () async {
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now().subtract(Duration(days: 365)),
                          lastDate: DateTime.now().add(Duration(days: 365)));
                      if (newDate == null) return;
                      setState(() {
                        isSelected = true;
                        selectedDate = newDate;
                      });
                    },
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.selected_date,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: settingProvider.IsDarkEnabled()
                                      ? Colors.white
                                      : MyThemeData.darkprimary),
                            ),
                            Icon(Icons.date_range_outlined,
                                color: settingProvider.IsDarkEnabled()
                                    ? Colors.white
                                    : MyThemeData.darkprimary),
                          ],
                        )),
                  ),
                ),
                Visibility(
                  visible: isSelected,
                  child: Text(
                      '${selectedDate?.year} / ${selectedDate?.month}/${selectedDate?.day}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Visibility(
                        visible: isSelected1,
                        child: Text(
                          'please select a date',
                          style: TextStyle(color: Color(0xffd32f2f)),
                        )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Container(
            color: settingProvider.IsDarkEnabled()
                ? MyThemeData.darkprimary
                : MyThemeData.lightSecondry,
            width: double.infinity,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton(
                onPressed: () {
                  DateValidation();
                  setState(() {
                    AddTask();
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text( AppLocalizations.of(context)!.add_task)),
          )
        ],
      ),
    );
  }

  void AddTask() async {
    if (FormKey.currentState?.validate() == false) {
      return;
    }
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    Task task = Task(
      title: TaskController.text,
      description: DsecController.text,
      datetime: Timestamp.fromMillisecondsSinceEpoch(
          //selectedDate!.millisecondsSinceEpoch
          selectedDate?.millisecondsSinceEpoch ?? 0),
    );
    widget.task?.title = TaskController.text;
    widget.task?.description = DsecController.text;
    widget.task?.datetime = Timestamp.fromMillisecondsSinceEpoch(
        selectedDate?.millisecondsSinceEpoch ?? 0);

    widget.edit == true
        ? null
        : DialogUtilits.ShowLoading(context, 'Creating Task...');
    widget.edit == true
        ? await authProvider.editing(
            widget.task, authProvider.databaseUser!.id!)
        : await TaskDao.createTask(task, authProvider.databaseUser!.id!);

    widget.edit == true ? null : DialogUtilits.HideDialog(context);
    widget.edit == true
        ? DialogUtilits.ShowMessage(context, 'Task Edited Successfully!',
            posActionTitle: 'OK', posAction: () {
            Navigator.pop(context);
          }, isCancelable: false)
        : DialogUtilits.ShowMessage(context, 'Task Created Successfully!',
            posActionTitle: 'OK', posAction: () {
            Navigator.pop(context);
          }, isCancelable: false);
  }

  void DateValidation() {
    if (selectedDate == null) {
      isSelected1 = true;
    } else {
      isSelected1 = false;
    }
  }
}
