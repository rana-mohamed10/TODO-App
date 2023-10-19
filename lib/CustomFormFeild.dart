import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/providers/SettingProvider.dart';

typedef Validator = String? Function(String?);

class CustomFormFeild extends StatelessWidget {
  String hint;
  TextInputType keyboardtype;
  bool secureText;
  Validator? validator;
  TextEditingController? controller;
  Color? color;
  Color labelStyle;


  CustomFormFeild({
    required this.hint,
    this.secureText = false,
    this.keyboardtype = TextInputType.text,
    this.validator,
    this.controller,
    this.labelStyle=Colors.white
  });

  @override
  Widget build(BuildContext context) {
    var settingProv=Provider.of<SettingProvider>(context);
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: secureText,
      keyboardType: keyboardtype,
      style: TextStyle(color:settingProv.IsDarkEnabled()? Colors.white:Colors.black),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: labelStyle
          )
        ),
        labelText: hint,
        labelStyle: TextStyle(color: labelStyle),
      ),
    );
  }

}