import 'package:evolution/character.dart';

final String columnText = "text";
final String columnType = "type";

class CharacterIndex {
  static const int INDEX_TYPE_PINYIN = 1;
  static const int INDEX_TYPE_RADICAL = 2;
  String text;
  bool isTitle = false;
  bool isSelected = false;
  int type;
  int stroke;
  CharacterIndex({this.text, this.isTitle = false, this.type, this.stroke});

  CharacterIndex.fromList(List<dynamic> list) {
    if(list.isNotEmpty) {
      text = list[0];
      if(list.length > 1) {
        stroke = list[1];
        type = INDEX_TYPE_RADICAL;
      } else {
        type = INDEX_TYPE_PINYIN;
      }
    }
  }

  CharacterIndex.fromMap(Map<String, dynamic> map) {
    text = map[columnText];
    type = map[columnType];
    stroke = map[columnStroke];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      columnText: text,
      columnType: type,
      columnStroke: stroke
    };
  }

  @override
  bool operator ==(other) {
    if(other is CharacterIndex) {
      return text == other.text;
    } else if(other is String) {
      return text == other;
    }
    return this == other;
  }
}