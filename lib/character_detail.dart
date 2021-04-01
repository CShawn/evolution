import 'package:flutter/material.dart';
import 'package:evolution/character.dart';
import 'package:evolution/character_background.dart';
import 'package:evolution/constants.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

// ignore: must_be_immutable
class CharacterDetailPage extends StatelessWidget {
  final Character _character;
  double _primaryCharacterRectSize = 100;
  double _primaryCharacterFontSize = 68;
  double _secondaryCharacterRectSize = 80;
  double _secondaryCharacterFontSize = 60;
  double _secondaryCharacterFontSize2 = 45;
  int _originFontCount = 5;

  CharacterDetailPage(this._character);

  @override
  Widget build(BuildContext context) {
    int count =  _originFontCount + (_character.traditional?.length ?? 0);
    return Scaffold(
      appBar: AppBar(title: Text(_character.character)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              Container(
                  child: Stack(children: <Widget>[
                    CustomPaint(painter: CharacterBackground(), size: Size(_primaryCharacterRectSize, _primaryCharacterRectSize),),
                    Container(
                      child: Text(
                        _character.character,
                        style: TextStyle(
                          fontSize: _primaryCharacterFontSize,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      width: _primaryCharacterRectSize,
                      height: _primaryCharacterRectSize,
                      alignment: Alignment.center,
                    ),
                  ]),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("${FlutterI18n.translate(context, strPinyin)} : ${_character.pinyin.join(charSeparator)}"),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text("${FlutterI18n.translate(context, strRadical)} : ${_character.radical}"),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text("${FlutterI18n.translate(context, strStroke)} : ${_character.stroke}"),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text("${FlutterI18n.translate(context, strFiveStroke)} : ${_character.fiveStroke}"),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text("${FlutterI18n.translate(context, strAreaCode)} : ${_character.areaCode}"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            Container(
              height: _secondaryCharacterRectSize,
              margin: EdgeInsets.only(top: 10),
              child: ListView.builder(
                itemCount: count,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return _getItemContainer(context, index);
                },
              ),
            ),
            Container(
              child: Text(
                "${FlutterI18n.translate(context, strMeaning)} :",
                style: TextStyle(color: mainColor, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.only(top: 10),
            ),
            Text(_character.meaning, textAlign: TextAlign.left),
          ],
        ),
      )
    );
  }

  _getItemContainer(BuildContext context, int index) {
    String font;
    String text = _character.character;
    if(index == 0) {
      font = fontBigSeal;
    } else if(index == 1) {
      font = fontHYBigSeal;
    } else if(index == 2) {
      font = fontSmallSeal;
    } else if (index == 3) {
      font = fontSquareSeal;
    } else if (index == 4) {
      font = fontNineFoldSeal;
    } else {
      int i = index - _originFontCount;
      if(i >= 0 && i < _character.traditional.length) {
        text = _character.traditional[i];
      } else {
        return null;
      }
    }
    return Container(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: font,
          fontSize: index < _originFontCount ? _secondaryCharacterFontSize : _secondaryCharacterFontSize2,
        )
      ),
//      decoration: BoxDecoration(
//          border: Border.all(color: primaryColor, width: 2)
//      ),
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: 10),
    );
  }
}