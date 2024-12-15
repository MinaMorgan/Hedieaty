import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabaseManager {
  static final LocalDatabaseManager _instance =
      LocalDatabaseManager._internal();
  factory LocalDatabaseManager() => _instance;
  LocalDatabaseManager._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'hedieaty.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        date TEXT,
        isPublic INT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS gifts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        event_id TEXT NOT NULL,
        userId TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT,
        price REAL,
        status TEXT,
        isPublic INT
      )
    ''');

    print("Database created and tables initialized.");
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////// Events ////////////////////////////////////////////
  Future<void> insertEvent(Map<String, dynamic> event) async {
    final db = await database;
    await db.insert('events', event);
  }

  Future<List<Map<String, dynamic>>> getEvents(String userId) async {
    final db = await database;
    return await db.query('events', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<void> updateEvent(
      int eventId, Map<String, dynamic> updatedEvent) async {
    final db = await database;
    await db
        .update('events', updatedEvent, where: 'id = ?', whereArgs: [eventId]);
  }

  Future<void> removeEvent(int eventId) async {
    final db = await database;
    await db.delete('events', where: 'id = ?', whereArgs: [eventId]);
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////// Gifts ////////////////////////////////////////////
  Future<int> insertGift(Map<String, dynamic> gift) async {
    final db = await database;
    return await db.insert('gifts', gift);
  }

  Future<List<Map<String, dynamic>>> getGifts(int eventId) async {
    final db = await database;
    return await db.query('gifts', where: 'event_id = ?', whereArgs: [eventId]);
  }

  Future<int> deleteGift(int giftId) async {
    final db = await database;
    return await db.delete('gifts', where: 'id = ?', whereArgs: [giftId]);
  }
}
