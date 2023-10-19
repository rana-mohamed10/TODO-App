import 'package:flutter/material.dart';

class DialogUtilits {
  static void ShowLoading(BuildContext context, String message,
      {bool isCancelable = true}) {
    showDialog(
      barrierDismissible: isCancelable,
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 6,),
                Text(message),
              ],
            ),
          );
        });
  }
  static void HideDialog(BuildContext context){
    Navigator.pop(context);
  }

  static void ShowMessage(BuildContext context, String message,
      {String? posActionTitle,
        String? negActionTitle,
        VoidCallback? posAction,
        VoidCallback? negAction,
        bool isCancelable = true}) {
    List<Widget> actions=[];
    if(posActionTitle!=null){
      actions.add(TextButton(onPressed: (){
        Navigator.pop(context);
        posAction?.call();
      },
          child: Text(posActionTitle)));
    }
    if(negActionTitle!=null){
      actions.add(TextButton(onPressed: (){
        Navigator.pop(context);
        negAction?.call();
      },
          child: Text(negActionTitle)));
    }
    showDialog(
        barrierDismissible: isCancelable,
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            actions: actions,
            content: Row(
              children: [
                Expanded(child: Text(message)),
              ],
            ),
          );
        });
  }

}
