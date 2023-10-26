import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/CustomFormFeild.dart';
import 'package:todo_list/DialogUtilits.dart';
import 'package:todo_list/FirebaseError.dart';
import 'package:todo_list/HomeScreen/HomeScreen.dart';
import 'package:todo_list/MyThemeData.dart';
import 'package:todo_list/Register/Register.dart';
import 'package:todo_list/ValidationUtils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_list/providers/SettingProvider.dart';


import '../providers/AuthProvider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "Login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  var FormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var settingProvider=Provider.of<SettingProvider>(context);
    return Scaffold(
      backgroundColor: settingProvider.IsDarkEnabled()
        ? MyThemeData.darkprimary
        : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/Group_9672.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.login,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20)),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Form(
                key: FormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomFormFeild(
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'please enter your Email';
                        }
                        if (!ValidatedEmail(text)) {
                          return 'Please enter a valid email format';
                        }
                        return null;
                      },
                      controller: emailController,
                      hint: AppLocalizations.of(context)!.email,
                      keyboardtype: TextInputType.emailAddress,
                      labelStyle:settingProvider.IsDarkEnabled()
                          ? Colors.white
                          : MyThemeData.darkprimary,
                    ),
                    CustomFormFeild(
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'please enter your Password';
                        }
                        return null;
                      },
                      controller: passwordController,
                      secureText: true,
                      hint: AppLocalizations.of(context)!.password,
                      labelStyle: settingProvider.IsDarkEnabled()
                          ? Colors.white
                          : MyThemeData.darkprimary,
                    ),

                    SizedBox(
                      height: 12,
                    ),
                    SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: ElevatedButton(
                            onPressed: () {
                              Login();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(AppLocalizations.of(context)!.login)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: InkWell( onTap: (){
                        Navigator.of(context).pushReplacementNamed(Register.routeName);
                      },
                          child: Text(AppLocalizations.of(context)!.dont_have_account,
                            style: TextStyle(color: Colors.blue),)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void Login() async {
    if (FormKey.currentState?.validate() == false) {
      return;
    }
    var authProvider = Provider.of<AuthProvider>(context,listen: false);
    try {
      DialogUtilits.ShowLoading(context, 'Loading...', isCancelable: false);
      await authProvider.Login(emailController.text, passwordController.text);
      DialogUtilits.HideDialog(context);
      DialogUtilits.ShowMessage(
        context,
        'Logged in Successfully!',
        posActionTitle: "OK",
        posAction: () {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        },
      );
    } on FirebaseAuthException catch (e) {
      DialogUtilits.HideDialog(context);
      if (e.code == FireBaseError.userNotFound ||
          e.code == FireBaseError.invalidCredential ||
          e.code == FireBaseError.wrongPass) {
        DialogUtilits.ShowMessage(context, 'email or password is wrong.'
        ,posActionTitle: 'OK');
      }
    }
  }
}
