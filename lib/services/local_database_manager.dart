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
      description TEXT NOT NULL,
      date TEXT NOT NULL,
      isPublic INT NOT NULL CHECK (isPublic IN (0,1))
    )
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS gifts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      eventId TEXT NOT NULL,
      userId TEXT NOT NULL,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      category TEXT NOT NULL,
      price INT NOT NULL,
      status INT NOT NULL CHECK (status IN (0,1)),
      pledgeUserId TEXT,
      pledgeUserName TEXT,
      pledgeDate TEXT
    )
  ''');
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////// Events ////////////////////////////////////////////
  Future<int> addEvent(Map<String, dynamic> event) async {
    final db = await database;
    return await db.insert('events', event);
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

  Future<List<Map<String, dynamic>>> getEvents(String userId) async {
    final db = await database;
    return await db.query('events', where: 'userId = ?', whereArgs: [userId]);
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////// Gifts ////////////////////////////////////////////
  Future<void> addGift(Map<String, dynamic> gift) async {
    final db = await database;
    await db.insert('gifts', gift);
  }

  Future<void> updateGift(int giftId, Map<String, dynamic> updatedGift) async {
    final db = await database;
    await db.update('gifts', updatedGift, where: 'id = ?', whereArgs: [giftId]);
  }

  Future<void> removeGift(int giftId) async {
    final db = await database;
    await db.delete('gifts', where: 'id = ?', whereArgs: [giftId]);
  }

  Future<void> removeGiftByEventId(String eventId) async {
    final db = await database;
    await db.delete('gifts', where: 'eventId = ?', whereArgs: [eventId]);
  }

  Future<Map<String, dynamic>> getGift(int giftId) async {
    final db = await database;
    final result = await db.query(
      'gifts',
      where: 'id = ?',
      whereArgs: [giftId],
      limit: 1,
    );
    return result.first;
  }

  Future<List<Map<String, dynamic>>> getGiftsByEventId(String eventId) async {
    final db = await database;
    return await db.query('gifts', where: 'eventId = ?', whereArgs: [eventId]);
  }
}
