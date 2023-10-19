import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/HomeScreen/HomeScreen.dart';
import 'package:todo_list/Login/LoginScreen.dart';
import 'package:todo_list/providers/AuthProvider.dart';
import 'package:todo_list/providers/SettingProvider.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = 'SplashScreen';

  @override
  Widget build(BuildContext context) {
    var settingProvider = Provider.of<SettingProvider>(context);
    return FutureBuilder(
      future: settingProvider.loadTheme(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting
        } else {
          String? theme = settingProvider.getTheme();
          Future.delayed(Duration(seconds: 2), () {
            navigate(context);
          });
          return Scaffold(
            body: Image(
              fit: BoxFit.fill,
              width: double.infinity,
              image: theme == 'light'
                  ? AssetImage('assets/images/splash.png')
                  : AssetImage('assets/images/splash-dark.png'),
            ),
          );
        }
      },
    );
  }

  void navigate(context) async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isUserLoggedInBefore()) {
      await authProvider.retrieveUserFromDatabase();
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    } else {
      Navigator.of(context).pushNamed(LoginScreen.routeName);
    }
  }
}