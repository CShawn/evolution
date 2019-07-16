import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:evolution/constants.dart';

class InfoDialog extends Dialog {
  String _version;
  InfoDialog(this._version);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AlertDialog(
            content: Container(
              child: Column(
                children: <Widget>[
                  Image(image: AssetImage("assets/logo.png"),
                    width: 72,
                    height: 72,
                  ),
                  Text(FlutterI18n.translate(context, strAppTitle)),
                  Container(
                    child: Text(_version),
                    margin: EdgeInsets.all(10),
                  ),
                  Text(
                    copyRight,
                    style: TextStyle(
                        color: Colors.grey
                    ),
                  ),
                  Text(
                    author,
                    style: TextStyle(
                        color: Colors.grey
                    ),
                  ),
                ],
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            )
        )
      ],
    );
  }
}