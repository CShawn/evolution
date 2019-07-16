import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:package_info/package_info.dart';
import 'package:evolution/database.dart';
import 'package:evolution/character_detail.dart';
import 'package:evolution/content_page.dart';
import 'package:evolution/constants.dart';
import 'package:evolution/info_dialog.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}): super(key: key);
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  GlobalKey<ListPageState> pageKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 5),
                child: TextField(
                  controller: textEditingController,
                  keyboardType: TextInputType.text,
                  maxLength: 1,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: FlutterI18n.translate(context, strSearchHint),
                    hintStyle: TextStyle(
                      color: greyColor
                    ),
                    focusColor: Colors.white,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white
                      )
                    )
                  ),
                  textInputAction: TextInputAction.search,
                  style: TextStyle(
                    color: Colors.white
                  ),
                  onEditingComplete: () {
                    _retrieve(context, textEditingController.text);
                  },
                )
              ),
            ),
            FlatButton(
                child: Text(FlutterI18n.translate(context, strSearch)),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30)
                  ),
                  side: BorderSide(
                    color: Colors.white,
                    style: BorderStyle.solid,
                    width: 2
                  )
                ),
                onPressed: () {
                  _retrieve(context, textEditingController.text);
                })
          ]),
        leading: IconButton(
          icon: Text(
            leadingText,
            style: TextStyle(
              fontFamily: fontSmallSeal,
              fontSize: 30
            ),
          ),
          tooltip: FlutterI18n.translate(context, strAbout),
          onPressed: () {
            _showAboutDialog();
          },
        ),
      ),
//      body: ListPage(),
      body: ListPage(key: pageKey),
    );
  }

  initializedDatabase() {
    pageKey.currentState.queryIndices();
  }

  _retrieve(BuildContext context, String text) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if(text.isEmpty || pageKey.currentState.initializing) {
      return;
    }
    DatabaseUtil().queryCharacter(text).then((character) {
      if(character != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CharacterDetailPage(character))
        );
      } else {
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text(
                "${FlutterI18n.translate(context, strRetrieveFailure)}: $text"
            ))
        );
      }
    });
  }

  _showAboutDialog() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    showDialog(
      context: context,
      builder: (context) {
        return InfoDialog(info.version);
      }
    );
  }
}