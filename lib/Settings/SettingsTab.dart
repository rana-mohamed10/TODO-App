import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/Settings/LanguageBottomSheet.dart';
import 'package:todo_list/Settings/ThemeBottomSheet.dart';
import 'package:todo_list/providers/SettingProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../MyThemeData.dart';

class SettingsTab extends StatefulWidget {
  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {

    var provider=Provider.of<SettingProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 64,
        horizontal: 18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.theme,
            style: TextStyle(fontSize: 20,
              color:provider.IsDarkEnabled()
                   ? Colors.white
                  : MyThemeData.darkprimary
                  ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              ShowThemeBottomSheet();
            },
            child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  provider.currentTheme==ThemeMode.dark
                      ?AppLocalizations.of(context)!.dark
                      :AppLocalizations.of(context)!.light,
                  style: TextStyle(fontSize: 18,
                    color:provider.IsDarkEnabled()
                        ? Colors.white
                        : MyThemeData.darkprimary ),
                  textAlign: TextAlign.start,
                ),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: provider.IsDarkEnabled()
                      ? MyThemeData.darkprimary
                      : Colors.white,
                  border: Border.all(
                    color: MyThemeData.lightprimary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                )),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            AppLocalizations.of(context)!.language,
            style: TextStyle(fontSize: 20,
              color:provider.IsDarkEnabled()
                  ? Colors.white
                  : MyThemeData.darkprimary),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              ShowLanguageBottomSheet();
            },
            child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  provider.currentLocale=='ar'
                      ?'العربية'
                      :'English',
                  style: TextStyle(fontSize: 18,
                  color:provider.IsDarkEnabled()
                      ? Colors.white
                      : MyThemeData.darkprimary ),
                  textAlign: TextAlign.start,
                ),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: provider.IsDarkEnabled()
                      ? MyThemeData.darkprimary
                      : Colors.white,
                  border: Border.all(
                    color: MyThemeData.lightprimary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                )),
          ),
        ],
      ),
    );
  }

  void ShowThemeBottomSheet() {
    var provider=Provider.of<SettingProvider>(context, listen: false);

    showModalBottomSheet(

      context: context,
      builder: (context)
      {
        return Container(
          color:provider.IsDarkEnabled()
              ? MyThemeData.darkprimary
              :MyThemeData.lightSecondry,
          child: Column(
            children: [ ThemeBottomSheet()],
          ),
          // child: ,
        );
      },
    );
  }

  void ShowLanguageBottomSheet() {
    var provider=Provider.of<SettingProvider>(context, listen: false);

    showModalBottomSheet(

      context: context,
      builder: (context) {
        return Container(
          color: provider.IsDarkEnabled()
              ? MyThemeData.darkprimary
              : MyThemeData.lightSecondry,
          child: Column(
            children: [LanguageBottomSheet()],
          ),
          // child: ,
        );
      },
    );
  }
}
