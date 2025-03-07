import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/notes.dart';

final String dbName = "notes_database.db";
final String tableName = "notes"; // Define the table name correctly

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database.
    final path = join(databasePath, dbName);

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, description TEXT, time TEXT)',
    );
  }

  // Future<void> insertNote(Notes note) async {
  //   final db = await _databaseService.database;
  //
  //   // Insert the Note into the 'notes' table
  //   await db.insert(
  //     tableName,
  //     note.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }
  Future<void> insertNote(Notes note1, Notes note2) async {
    final db = await _databaseService.database;

    // Insert two notes into the 'notes' table
    await db.insert(
      tableName,
      note1.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.insert(
      tableName,
      note2.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Notes>> getNotes() async {
    try {
      final db = await _databaseService.database;

      // Query the 'notes' table for all the notes
      final List<Map<String, dynamic>> maps = await db.query(tableName);

      return List.generate(maps.length, (index) => Notes.fromMap(maps[index]));
    } catch (e) {
      print("ERRORDB - $e");
      rethrow;
    }
  }
}
