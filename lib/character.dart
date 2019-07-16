final String columnCharacter = "character";
final String columnTraditional = "traditional";
final String columnPinyin = "pinyin";
final String columnRadical = "radical";
final String columnStroke = "stroke";
final String columnFiveStroke = "fiveStroke";
final String columnAreaCode = "areaCode";
final String columnStrokeOrder = "strokeOrder";
final String columnMeaning = "meaning";
const String charSeparator = "、";

class Character {
  String character;
  List<String> traditional;
  List<String> pinyin;
  String radical;
  int stroke;
  String fiveStroke;
  String areaCode;
  String strokeOrder;
  String meaning;
  bool isTitle = false;
  bool isSelected = false;

  Character(this.stroke, {this.isTitle = true});

  Character.fromMap(Map<String, dynamic> map) {
    character = map[columnCharacter];
    traditional = map[columnTraditional].toString().split(charSeparator);
    pinyin = map[columnPinyin].toString().split(charSeparator);
    radical = map[columnRadical];
    stroke = map[columnStroke];
    fiveStroke = map[columnFiveStroke];
    areaCode = map[columnAreaCode];
    strokeOrder = map[columnStrokeOrder];
    meaning = map[columnMeaning];
  }

  Character.fromList(List<dynamic> list) {
    character = list.length > 0 ? list[0] : null;
    pinyin = list.length > 1 ? list[1].toString().split(charSeparator) : null;
    radical = list.length > 2 ? list[2] : null;
    stroke = list.length > 3 ? (int.tryParse(list[3]) ?? 0) : 0;
    traditional = list.length > 4 ? list[4].toString().split(charSeparator) : null;
    fiveStroke = list.length > 5 ? list[5] : null;
    areaCode = list.length > 6 ? list[6] : null;
    strokeOrder = list.length > 7 ? list[7] : null;
    meaning = list.length > 8 ? list[8] : null;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      columnCharacter: character,
      columnTraditional: traditional.join(charSeparator),
      columnPinyin: pinyin.join(charSeparator),
      columnRadical: radical,
      columnStroke: stroke,
      columnFiveStroke: fiveStroke,
      columnAreaCode: areaCode,
      columnStrokeOrder: strokeOrder,
      columnMeaning: meaning
    };
  }

  @override
  bool operator ==(other) {
    if(other is Character) {
      return character == other.character;
    }
    return this == other;
  }
}