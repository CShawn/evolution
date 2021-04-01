import 'package:flutter/material.dart';
import 'package:evolution/application.dart';
import 'package:evolution/homepage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:evolution/database.dart';
import 'package:evolution/character.dart';
import 'package:evolution/character_index.dart';
import 'package:evolution/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  GlobalKey<HomePageState> homePageKey = GlobalKey();
  String initSQLKey = "initSQL";
  @override
  void initState() {
    super.initState();
    applic.onLocaleChanged = onLocaleChange;
  }

  onLocaleChange(Locale locale) {
    setState(() {
      FlutterI18n.refresh(context, locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    _initDatabase();
    return MaterialApp(
      theme: ThemeData(
        primaryColor: mainColor,
        buttonColor: mainColor,
        accentColor: mainColor,
      ),
      localizationsDelegates: [
        FlutterI18nDelegate(path: "assets/flutter_i18n"),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: applic.supportedLocales(),
//      home: HomePage(),
    home: HomePage(key: homePageKey),
    );
  }

  _initDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    bool isInit = prefs.get(initSQLKey) ?? false;
    if(!isInit) {
      String content = await rootBundle.loadString("assets/characters.csv");
      final int count = 7920;
      int progress = 0;
      int temp = 0;
      List<List<dynamic>> list = const CsvToListConverter(shouldParseNumbers: false).convert(content);
      list.forEach((item) {
        DatabaseUtil().insertCharacter(Character.fromList(item))
            .then((result) {
          print("chr-in:$result/${list.length}");
          if(result > 0) {
            progress = result * 100 ~/ count;
            homePageKey.currentState.pageKey.currentState.setState((){
              homePageKey.currentState.pageKey.currentState.progress = progress;
            });
          }
        });
      });

      content = await rootBundle.loadString("assets/pinyin.csv");
      List<List<dynamic>> list2 = const CsvToListConverter().convert(content);
      list2.forEach((item) {
        DatabaseUtil().insertCharacterIndex(CharacterIndex.fromList(item))
            .then((result) {
          print("py-in:$result/${list2.length}");
          if(result > 0) {
            temp = result * 100 ~/ count;
            homePageKey.currentState.pageKey.currentState.setState(() {
              homePageKey.currentState.pageKey.currentState.progress = progress;
            });
          }
        });
      });
      progress += temp;

      content = await rootBundle.loadString("assets/radicals.csv");
      List<List<dynamic>> list3 = const CsvToListConverter().convert(content);
      list.forEach((item) {
        DatabaseUtil().insertCharacterIndex(CharacterIndex.fromList(item))
            .then((result) {
          print("ra-in:$result/${list3.length}");
          if(result > 0) {
            temp = result * 100 ~/ count;
            homePageKey.currentState.pageKey.currentState.setState(() {
              homePageKey.currentState.pageKey.currentState.progress = progress;
            });
          }
        });
      });
      prefs.setBool(initSQLKey, true);
      prefs.commit();
      homePageKey.currentState.initializedDatabase();
    } else {
      print("sql initialized");
    }
  }
}
