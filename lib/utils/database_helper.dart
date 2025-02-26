import 'dart:async';
import 'package:challenges/core/configs/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? _database;

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'notes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${Constants.TABLE_NAME} (
            ${Constants.COLUM_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${Constants.COLUM_DATE} TEXT,
            ${Constants.COLUM_TEXT} TEXT
          )
        ''');
      },
    );
  }

  // Add a new note
  Future<int> addNote(Map<String, dynamic> note) async {
    Database db = await database;
    return await db.insert(Constants.TABLE_NAME, note);
  }

  // Get all notes
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    Database db = await database;
    return await db.query(Constants.TABLE_NAME);
  }

  // Get a single note by its ID
  Future<Map<String, dynamic>?> getNoteById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      Constants.TABLE_NAME,
      where: '${Constants.COLUM_ID} = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Update an existing note
  Future<int> updateNote(Map<String, dynamic> note) async {
    Database db = await database;
    return await db.update(
      Constants.TABLE_NAME,
      note,
      where: '${Constants.COLUM_ID} = ?',
      whereArgs: [note[Constants.COLUM_ID]],
    );
  }

  // Delete a note by its ID
  Future<int> deleteNoteById(int id) async {
    Database db = await database;
    return await db.delete(
      Constants.TABLE_NAME,
      where: '${Constants.COLUM_ID} = ?',
      whereArgs: [id],
    );
  }

  // Delete all notes
  Future<int> deleteAllNotes() async {
    Database db = await database;
    return await db.delete(Constants.TABLE_NAME);
  }
}
