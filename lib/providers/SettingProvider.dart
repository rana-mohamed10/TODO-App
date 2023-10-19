import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends ChangeNotifier{
  SharedPreferences? preference;
  ThemeMode currentTheme=ThemeMode.light;
  String currentLocale='en';

  void changeTheme(ThemeMode newMode){
    if (currentTheme==newMode)return;
    currentTheme=newMode;
    SaveTheme(currentTheme);
    notifyListeners();

  }
  void ChangeLang(locale){
    if (currentLocale==locale)return;
    currentLocale=locale;
    SaveLocale(locale);
    notifyListeners();
  }
  Color GetBackground(){
    return currentTheme==ThemeMode.dark
        ? Colors.black
        :Color(0xFFDEEBDA) ;
  }
  bool IsDarkEnabled(){
    return currentTheme==ThemeMode.dark;
  }

  Future<void>SaveTheme(ThemeMode theme)async{
     String mode= theme==ThemeMode.dark
         ?'dark'
         :'light';
     await preference?.setString('theme', mode);
  }

  String? getTheme(){
    return preference?.getString('theme');
  }
  Future<void>loadTheme() async{
    preference= await SharedPreferences.getInstance();
    String? theme=getTheme();
    if (theme !=null){
      theme=='dark'
          ?currentTheme=ThemeMode.dark
          :currentTheme=ThemeMode.light;
    }
  }

  Future<void>SaveLocale(String locale)async{
    String lang= locale=='en'
        ?'en'
        :'ar';
    await preference?.setString('language', lang);
  }

  String? getLocale(){
    return preference?.getString('language');
  }
  Future<void>loadLocale() async{
    preference= await SharedPreferences.getInstance();
    String? locale=getLocale();
    if (locale !=null){
      locale=='en'
          ?currentLocale='en'
          :currentLocale='ar';
    }
  }
}