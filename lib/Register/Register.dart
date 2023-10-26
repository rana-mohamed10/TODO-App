import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/CustomFormFeild.dart';
import 'package:todo_list/Database/model/User.dart' as MyUser;
import 'package:todo_list/Database/UserDao.dart';
import 'package:todo_list/DialogUtilits.dart';
import 'package:todo_list/FirebaseError.dart';
import 'package:todo_list/Login/LoginScreen.dart';
import 'package:todo_list/MyThemeData.dart';
import 'package:todo_list/ValidationUtils.dart';
import 'package:todo_list/providers/AuthProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_list/providers/SettingProvider.dart';


class Register extends StatefulWidget {
  static const String routeName = "Register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController fullNameController = TextEditingController();

  TextEditingController userNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

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
                    child: Text(AppLocalizations.of(context)!.create_account,
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
                          return 'please enter Full Name';
                        }
                        return null;
                      },
                      controller: fullNameController,
                      hint: AppLocalizations.of(context)!.full_name,
                      labelStyle: settingProvider.IsDarkEnabled()
                          ? Colors.white
                          : MyThemeData.darkprimary,
                    ),
                    CustomFormFeild(
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'please enter User Name';
                        }
                        return null;
                      },
                      controller: userNameController,
                      hint: AppLocalizations.of(context)!.user_name,
                      labelStyle: settingProvider.IsDarkEnabled()
                          ? Colors.white
                          : MyThemeData.darkprimary,
                    ),
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
                      labelStyle: settingProvider.IsDarkEnabled()
                          ? Colors.white
                          : MyThemeData.darkprimary,
                    ),
                    CustomFormFeild(
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'please enter your Password';
                        }
                        if (text.length < 6) {
                          return 'Password should be at least 6 characters';
                        }
                        return null;
                      },
                      controller: passwordController,
                      secureText: true,
                      hint:AppLocalizations.of(context)!.password,
                      labelStyle: settingProvider.IsDarkEnabled()
                          ? Colors.white
                          : MyThemeData.darkprimary,
                    ),
                    CustomFormFeild(
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'please enter your Password';
                        }
                        if (passwordController.text != text) {
                          return 'Password Does not match!';
                        }
                        return null;
                      },
                      controller: confirmPasswordController,
                      secureText: true,
                      hint: AppLocalizations.of(context)!.re_password,
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
                              createAccount();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(AppLocalizations.of(context)!.create_account)),
                      ),
                    ),
                    TextButton(onPressed: (){
                      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                    }, child: Text(AppLocalizations.of(context)!.already_have_account))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void createAccount() async{
    if (FormKey.currentState?.validate() == false) {
      return;
    }
    var authProvider = Provider.of<AuthProvider>(context,listen: false);
    //if valid call register on firebase auth
    try{
      DialogUtilits.ShowLoading(context, 'Loading...',isCancelable: false);
      await authProvider.Register(emailController.text, passwordController.text,
          fullNameController.text, userNameController.text);
      DialogUtilits.HideDialog(context);
      DialogUtilits.ShowMessage(context, 'Account Created Successfully!',
          posActionTitle: "OK",
          posAction: (){
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
          },
          negActionTitle: "Cancel");
    }
    on FirebaseAuthException catch (e) {
      if (e.code == FireBaseError.weakPass) {
        DialogUtilits.ShowMessage(context,'The password provided is too weak.');
      } else if (e.code == FireBaseError.emailInUse) {
        DialogUtilits.ShowMessage(context,'The account already exists for that email.');

      }
    } catch (e) {
      DialogUtilits.HideDialog(context);
      DialogUtilits.ShowMessage(context, 'Something Went Wrong');
      print(e);

    }

  }
}
