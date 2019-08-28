import 'package:Minesweeper/model/highscoremodal.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static final DbHelper _instance = new DbHelper.internal();
  factory DbHelper() => _instance;

  static Database _db;
  static final Id = 'id';
  static final highScore = 'score';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initializeDatabase();
    return _db;
  }

  DbHelper.internal();

    Future<Database> initializeDatabase() async{
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "score1.db";
    var dbScores = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dbScores;
  }


  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE highscore(Id INTEGER PRIMARY KEY AUTOINCREMENT, Score INTEGER)");
  }



  static Future<String> dbPath() async {
    String path = await getDatabasesPath();
    return path;
  }



  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    var dbClient = await db;
    var result = await dbClient.query("Noteheader");
    return result;
  }

  Future<List<Map<String, dynamic>>> getHighScore() async {
    var dbClient = await db;
    var res = await dbClient.query("highscore");
    return res.isNotEmpty ? res : res;
  }

  Future<int> FristScoreinsert(int finalscore) async{
    // row to insert
    Map<String, dynamic> row = {
      DbHelper.highScore  : finalscore
    };
    Database db = await DbHelper._instance.initializeDatabase();

    var dbClient = await db;
    var raw = await dbClient.insert(
      "highscore",
      row,
    );
    return raw;
  }

  Future<int> bestScoreupdate(int finalscore) {


  }






}
