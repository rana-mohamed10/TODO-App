import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/HomeScreen/HomeScreen.dart';
import 'package:todo_list/Login/LoginScreen.dart';
import 'package:todo_list/MyThemeData.dart';
import 'package:todo_list/Register/Register.dart';
import 'package:todo_list/SplashScreen/Splash.dart';
import 'package:todo_list/firebase_options.dart';
import 'package:todo_list/providers/AuthProvider.dart';
import 'package:todo_list/providers/SettingProvider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var settingProvider=SettingProvider();
  await settingProvider.loadTheme();
  await settingProvider.loadLocale();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext buildContext) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext buildContext) => settingProvider,
        ),
      ],
      child: const MyApp(),
    ),
  );


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SettingProvider settingProvider=Provider.of<SettingProvider>(context);

    return MaterialApp(
      title: 'TODO-List',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      locale: Locale(settingProvider.currentLocale),
      theme: MyThemeData.lighttheme,
      darkTheme: MyThemeData.darktheme,
      themeMode: settingProvider.currentTheme,

      routes: {
        Register.routeName:(_)=>Register(),
        HomeScreen.routeName:(_)=>HomeScreen(),
        LoginScreen.routeName:(_)=>LoginScreen(),
        SplashScreen.routeName:(_)=>SplashScreen()

      },
      initialRoute: SplashScreen.routeName,
    );
  }
}

