import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safenote/data/network.dart';
import 'package:safenote/functions/file_access.dart';
import 'package:safenote/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static final columnBody = 'body';
  static final columnId = 'id';
  static final columnLastEdit = 'last_edit';
  static final columnPersonId = 'person_id';
  static final columnTitle = 'title';
  static final table = 'safe_table';

  static Database _database;
  static final _databaseName = "SafeNote.db";
  static final _databaseVersion = 1;
  static bool _isFirstOpen = true;
  static String _uuid;

  Future<Database> get database async {
    if (_database != null) return _database;

    _uuid = await getUuidFromFile();
    _database = await _initDb();
    return _database;
  }

  _initDb() async {
    Directory databasesPath = await getApplicationDocumentsDirectory();
    String path = join(databasesPath.path, _databaseName);
    var db = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);

    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    _uuid = Uuid().v4();
    saveUuid(_uuid);
    await db.execute('''
        CREATE TABLE $table(
          $columnId TEXT PRIMARY KEY, 
          $columnTitle TEXT, 
          $columnBody TEXT, 
          $columnLastEdit INTEGER,
          $columnPersonId TEXT
          )
        ''');
  }

  Future<int> saveNote(Note note, bool isUploadNeeded) async {
    if (isUploadNeeded) {
      note.id = await uploadSingleNote(note);
    }
    updateSingleNote(note);
    var db = await instance.database;
    var result = await db.insert(table, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return result;
  }

  String getUuid() {
    return _uuid;
  }

  Future<List<Note>> getAllNotes() async {
    var db = await instance.database;
    if (_isFirstOpen) {
      List<Note> noteListFromNetwork = await fetchNotes(getUuid());
      if (noteListFromNetwork != null && noteListFromNetwork.length != 0) {
        for (var note in noteListFromNetwork) {
          var result = await saveNote(note, false);
        }
      }
      _isFirstOpen = false;
    }

    var queryResults = await db.query(table, orderBy: '$columnLastEdit DESC');

    return queryResults.map((e) => Note.fromMap(e)).toList();
  }

  Future<int> update(Note note) async {
    var db = await instance.database;
    var result = await db.update(table, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
    updateSingleNote(note);
    return result;
  }

  Future<int> delete(int id) async {
    var db = await instance.database;
    var result =
        await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
    return result;
  }
}
