import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabaseManager {
  static final LocalDatabaseManager _instance = LocalDatabaseManager._internal();
  factory LocalDatabaseManager() => _instance;
  LocalDatabaseManager._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the models
  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'hedieaty.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        title TEXT NOT NULL,
        description TEXT,
        date TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS gifts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        event_id INTEGER,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT,
        price REAL,
        status TEXT,
        FOREIGN KEY (event_id) REFERENCES events (id)
      )
    ''');

    print("Database created and tables initialized.");
  }
  // CRUD for Events

  Future<int> insertEvent(Map<String, dynamic> event) async {
    final db = await database;
    return await db.insert('events', event);
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    final db = await database;
    return await db.query('events');
  }

  // CRUD for Gifts

  Future<int> insertGift(Map<String, dynamic> gift) async {
    final db = await database;
    return await db.insert('gifts', gift);
  }

  Future<List<Map<String, dynamic>>> getGifts(int eventId) async {
    final db = await database;
    return await db.query('gifts', where: 'event_id = ?', whereArgs: [eventId]);
  }

  // Example Delete methods for each table
  Future<int> deleteEvent(int eventId) async {
    final db = await database;
    return await db.delete('events', where: 'id = ?', whereArgs: [eventId]);
  }

  Future<int> deleteGift(int giftId) async {
    final db = await database;
    return await db.delete('gifts', where: 'id = ?', whereArgs: [giftId]);
  }
}
