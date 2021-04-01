import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'constants.dart';

class TextPage extends StatelessWidget {
  final String _text;
  TextPage(this._text);
  final double _size = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(FlutterI18n.translate(context, strText))),
      body: ListView.separated(
          itemCount: 6,
          separatorBuilder: (context, index) => Divider(height: 1.0, color: mainColor),
          itemBuilder: (context, position) {
            switch(position) {
              case 0:
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      _text,
                      style: TextStyle(
                          fontSize: _size
                      )
                  )
                );
              case 1:
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      _text,
                      style: TextStyle(
                          fontSize: _size,
                          fontFamily: fontBigSeal
                      )
                  )
                );
              case 2:
                return Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        _text,
                        style: TextStyle(
                            fontSize: _size,
                            fontFamily: fontHYBigSeal
                        )
                    )
                );
              case 3:
                return Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        _text,
                        style: TextStyle(
                            fontSize: _size,
                            fontFamily: fontSmallSeal
                        )
                    )
                );
              case 4:
                return Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        _text,
                        style: TextStyle(
                            fontSize: _size,
                            fontFamily: fontSquareSeal
                        )
                    )
                );
              case 5:
                return Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        _text,
                        style: TextStyle(
                            fontSize: _size,
                            fontFamily: fontNineFoldSeal
                        )
                    )
                );
              default:
                return Text(_text);
            }
          }
      )
    );
  }

}