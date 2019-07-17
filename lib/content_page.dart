import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:evolution/database.dart';
import 'package:evolution/character.dart';
import 'package:evolution/character_index.dart';
import 'package:evolution/character_detail.dart';
import 'package:evolution/constants.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key}): super(key: key);
  @override
  State<StatefulWidget> createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  ListPageState() {
    if(_pinYinIndices?.isEmpty != false) {
      initializing = true;
      queryIndices();
    } else {
      initializing = false;
    }
  }

  List<CharacterIndex> _pinYinIndices = [];
  List<CharacterIndex> _radicalIndices = [];
  List<Character> _characters = [];
  bool initializing = true;
  int progress = 0;

  @override
  Widget build(BuildContext context) {
    return initializing ? Center(
        child: Column(
          children: <Widget>[
            CircularProgressIndicator(),
            Container(
              child: Text(progress == 0 ? FlutterI18n.translate(context, strLoading) :
              "${FlutterI18n.translate(context, strInitProgress)}：$progress%"),
              margin: EdgeInsets.only(top: 15),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
    ) : Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Column(children: <Widget>[
              Container(
                  padding: EdgeInsets.all(1),
                  child: RaisedButton(
                      child: Text(FlutterI18n.translate(context, strSwitchStyle),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _switchSearchStyle();
                      }
                  )
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _indexType == CharacterIndex.INDEX_TYPE_PINYIN ?
                    _pinYinIndices.length : _radicalIndices.length,
                    itemBuilder: (context, position){
                      return _getIndexItem(context, position,
                          _indexType == CharacterIndex.INDEX_TYPE_PINYIN ?
                          _pinYinIndices[position] : _radicalIndices[position]);
                    }
                ),
              ),
            ])
        ),
        Expanded(
          flex: 4,
          child: StaggeredGridView.countBuilder(
              crossAxisCount: 5,
              itemCount: _characters.length,
              itemBuilder: (context, index) {
                return _getCharacterItem(context, index, _characters[index]);
              }, staggeredTileBuilder: (index){
            Character bean = _characters[index];
            return StaggeredTile.count(bean.isTitle ? 5 : 1, bean.isTitle ? 0.5 : 1);
          }
          ),
        )
      ],
    );
  }

  int _indexType = CharacterIndex.INDEX_TYPE_PINYIN;

  queryIndices() {
    _queryRadicals();
    _queryPinYinIndices();
  }

  _queryPinYinIndices() {
    if(_pinYinIndices.isEmpty) {
      DatabaseUtil().queryPinYin().then((values) {
        if(values?.isNotEmpty == true) {
          setState(() {
            values.forEach((pinyin) {
              if (_pinYinIndices.isEmpty || pinyin.text.codeUnitAt(0) !=
                  _pinYinIndices[_pinYinIndices.length - 1].text.codeUnitAt(0)) {
                _pinYinIndices.add(CharacterIndex(
                    text: pinyin.text.substring(0, 1).toUpperCase(),
                    isTitle: true,
                    type: CharacterIndex.INDEX_TYPE_PINYIN
                ));
              }
              _pinYinIndices.add(pinyin);
            });
            if(_pinYinIndices.isNotEmpty) {
              _pinYinIndices[1].isSelected = true;
              _retrieveCharacterByIndex(_pinYinIndices[1]);
            }
            initializing = false;
          });
        }
      });
    }
  }

  _queryRadicals() {
    if(_radicalIndices.isEmpty) {
      DatabaseUtil().queryRadicals().then((values) {
        if(values?.isNotEmpty == true) {
          setState(() {
            values.forEach((radical) {
              if (_radicalIndices.isEmpty ||
                  radical.stroke != _radicalIndices[_radicalIndices.length - 1].stroke) {
                _radicalIndices.add(CharacterIndex(
                    text: "${radical.stroke}$stokeStr",
                    isTitle: true,
                    type: CharacterIndex.INDEX_TYPE_RADICAL
                ));
              }
              _radicalIndices.add(radical);
            });
            if(_radicalIndices.isNotEmpty) {
              _radicalIndices[1].isSelected = true;
            }
          });
        }
      });
    }
  }

  _switchSearchStyle() {
    setState(() {
      if(_indexType == CharacterIndex.INDEX_TYPE_PINYIN) {
        _indexType = CharacterIndex.INDEX_TYPE_RADICAL;
        _retrieveCharacterByIndex(_radicalIndices.firstWhere((item) => item.isSelected));
      } else {
        _indexType = CharacterIndex.INDEX_TYPE_PINYIN;
        _retrieveCharacterByIndex(_pinYinIndices.firstWhere((item) => item.isSelected));
      }
    });
  }

  Widget _getIndexItem(BuildContext context, int index, CharacterIndex charIndex) {
    return GestureDetector(
      child: Container(
        child: Text(
          charIndex.text,
          style: TextStyle(
            color: charIndex.isTitle ? Colors.black :
            charIndex.isSelected ?Colors.white : mainColor,
            fontSize: 20,
          ),
          textAlign: charIndex.type == CharacterIndex.INDEX_TYPE_PINYIN ? TextAlign.left : TextAlign.center,
        ),
        padding: charIndex.type == CharacterIndex.INDEX_TYPE_PINYIN
            ? EdgeInsets.only(left: 5) : EdgeInsets.zero,
        color: charIndex.isSelected ? mainColor :
          charIndex.isTitle ? Colors.grey[300] : Colors.transparent,
      ),
      onTap: () {
        if(!charIndex.isTitle && !charIndex.isSelected) {
          setState(() {
            if(_indexType == CharacterIndex.INDEX_TYPE_PINYIN) {
              _pinYinIndices.forEach((i) => i.isSelected = false);
            } else if(_indexType == CharacterIndex.INDEX_TYPE_RADICAL){
              _radicalIndices.forEach((i) => i.isSelected = false);
            }
            charIndex.isSelected = true;
            _retrieveCharacterByIndex(charIndex);
          });
        }
      },
    );
  }

  Widget _getCharacterItem(BuildContext context, int index, Character character) {
    return GestureDetector(
      child: Container(
        child: Text(
            character.isTitle ? "${character.stroke}$stokeStr" : character.character,
            textAlign: character.isTitle ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: character.isTitle ? 18 : 36,
            )
        ),
        decoration: BoxDecoration(
          border: !character.isTitle ? Border.all(color: strokeColor, width: 1) : null,
          color: character.isTitle ? Colors.grey[300] : Colors.transparent,
        ),
        alignment: Alignment.center,
        margin: character.isTitle ? EdgeInsets.only(top: 4)
            : EdgeInsets.only(left: 4, right: 4, top: 4),
      ),
      onTap: () {
        if(!character.isTitle) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CharacterDetailPage(character))
          );
        }
      },
    );
  }

  _retrieveCharacterByIndex(CharacterIndex charIndex) async {
    var result = charIndex.type == CharacterIndex.INDEX_TYPE_PINYIN
        ? DatabaseUtil().queryCharactersByPinYin(charIndex.text)
        : DatabaseUtil().queryCharactersByRadical(charIndex.text);
    result.then((values){
      setState(() {
        _characters.clear();
        if(values?.isNotEmpty == true) {
          values.forEach((item) {
            if (_characters.isEmpty) {
              _characters.add(Character(item.stroke));
            } else {
              if (item.stroke != _characters[_characters.length - 1].stroke) {
                _characters.add(Character(item.stroke));
              }
            }
            _characters.add(item);
          });
        }
      });
    });
  }
}