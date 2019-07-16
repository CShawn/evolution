import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:evolution/character.dart';
import 'package:evolution/character_index.dart';
import 'package:evolution/constants.dart';

class DatabaseUtil {
  static DatabaseUtil _instance = DatabaseUtil._();

  Future<Database> _database;

  factory DatabaseUtil() => _sharedInstance();

  DatabaseUtil._() {
    _database = _init();
  }

  static DatabaseUtil _sharedInstance() {
    return _instance;
  }

  Future<Database> _init() async {
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
      onCreate: (db, version) {
          db.execute(
              "CREATE TABLE IF NOT EXISTS $tableCharacterIndex("
                  "$columnText TEXT UNIQUE NOT NULL,"
                  "$columnType INTEGER,"
                  "$columnStroke INTEGER);"
          );
          return db.execute(
              "CREATE TABLE IF NOT EXISTS $tableCharacter("
                  "$columnCharacter TEXT UNIQUE NOT NULL,"
                  "$columnTraditional TEXT,"
                  "$columnPinyin TEXT,"
                  "$columnRadical TEXT,"
                  "$columnStroke INTEGER,"
                  "$columnFiveStroke TEXT,"
                  "$columnAreaCode TEXT,"
                  "$columnStrokeOrder TEXT,"
                  "$columnMeaning TEXT);"
          );
      }
    );
  }

/*
  Future<List<CharacterIndex>> queryPinYin() async {
    String column = columnPinyin;
    Database db = await _database;
    List<Map<String, dynamic>> maps = await db.query(tableCharacterName, groupBy: column);
    if(maps?.isNotEmpty == true) {
      List<CharacterIndex> raw = List.generate(maps.length, (i) =>
          CharacterIndex(text: maps[i][column], type: CharacterIndex.INDEX_TYPE_PINYIN)
      );
      List<CharacterIndex> multi = raw.where((item) => item.text.contains(charSeparator)).toList();
      raw.removeWhere((item) => item.text.contains(charSeparator));
      multi = multi.expand((item) => List.from(item.text.split(charSeparator))
          .map((str) => CharacterIndex(text: str, type: CharacterIndex.INDEX_TYPE_PINYIN))
      ).toList();
      multi.forEach((pinyin) {
        if(!raw.contains(pinyin)) {
          raw.add(pinyin);
        }
      });
      raw.sort((item1, item2) {
        return item1.text.compareTo(item2.text);
      });
      return raw;
    }
    return null;
  }
*/

  Future<List<CharacterIndex>> queryPinYin() async {
    return _queryIndices(CharacterIndex.INDEX_TYPE_PINYIN);
  }

  Future<List<CharacterIndex>> queryRadicals() async {
    return _queryIndices(CharacterIndex.INDEX_TYPE_RADICAL);
  }

  Future<List<CharacterIndex>> _queryIndices(int type) async {
    try {
      Database db = await _database;
      List<Map<String, dynamic>> maps = await db.query(tableCharacterIndex,
          where: "$columnType=?", whereArgs: [type],
          orderBy: type == CharacterIndex.INDEX_TYPE_RADICAL
              ? columnStroke : columnText);
      if (maps?.isNotEmpty == true) {
        return List.generate(maps.length, (i) => CharacterIndex.fromMap(maps[i]));
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Character>> queryCharactersByPinYin(String text) async {
    Database db = await _database;
    List<Map<String, dynamic>> maps = await db.query(tableCharacter,
        where: "$columnPinyin = '$text' OR "
            "$columnPinyin like '$text$charSeparator%' OR "
            "$columnPinyin like '%$charSeparator$text$charSeparator%' OR "
            "$columnPinyin like '%$charSeparator$text'", orderBy: columnStroke);
    if(maps?.isNotEmpty == true) {
      return List.generate(maps.length, (i) => Character.fromMap(maps[i]));
    }
    return null;
  }

  Future<List<Character>> queryCharactersByRadical(String text) async {
    try {
      Database db = await _database;
      List<Map<String, dynamic>> maps = await db.query(tableCharacter,
          where: "radical=?", whereArgs: [text], orderBy: columnStroke);
      if(maps?.isNotEmpty == true) {
        return List.generate(maps.length, (i) => Character.fromMap(maps[i]));
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Character> queryCharacter(String text) async {
    try {
      Database db = await _database;
      List<Map<String, dynamic>> maps = await db.query(tableCharacter,
          where: "character=? OR traditional=?", whereArgs: [text, text]);
      if(maps?.isNotEmpty == true) {
        return Character.fromMap(maps.first);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<int> insertCharacter(Character character) async {
    try {
      Database db = await _database;
      return await db.insert(tableCharacter, character.toMap());
    } catch (e) {
      print(e);
    }
    return -1;
  }

  Future<int> insertCharacterIndex(CharacterIndex characterIndex) async {
    try {
      Database db = await _database;
      return await db.insert(tableCharacterIndex, characterIndex.toMap());
    } catch (e) {
      print(e);
    }
    return -1;
  }
}
