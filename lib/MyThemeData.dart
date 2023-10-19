
import 'package:flutter/material.dart';

class MyThemeData {
  static const Color lightprimary=Colors.blue;
  static const Color lightSecondry=Color(0xFFDEEBDA);
  static const Color darkprimary=Color(0xFF060E1E);
  static const Color darksecondry=Color(0xFF141922);



  static ThemeData lighttheme=  ThemeData(

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 30),
      ),
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: lightprimary,
        primary: Colors.blue,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: MyThemeData.lightSecondry,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.transparent,
          selectedIconTheme: IconThemeData(size: 32)),
     );

  static ThemeData darktheme=  ThemeData(

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 30),

      ),
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: ColorScheme.fromSeed(
          seedColor: darkprimary,
        primary: lightprimary
           ),
      useMaterial3: false,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: MyThemeData.darksecondry,
      ),
    floatingActionButtonTheme:const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue
    ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor:Colors.transparent,
          selectedItemColor: lightprimary,
          unselectedItemColor: Colors.white,
          elevation: 0,
          unselectedIconTheme:IconThemeData(color: Colors.white) ,
          selectedIconTheme: IconThemeData(size: 32)),
      );

}