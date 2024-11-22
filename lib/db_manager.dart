import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();

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
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

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

    await db.execute('''
      CREATE TABLE IF NOT EXISTS friends (
        user_id INTEGER,
        friend_id INTEGER,
        PRIMARY KEY (user_id, friend_id),
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (friend_id) REFERENCES users (id)
      )
    ''');

    print("Database created and tables initialized.");
  }

  // CRUD for Users

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<bool> getUser(String email, String password) async {
    final db = await database;
    final res = await db.rawQuery(
      'SELECT * FROM users WHERE email = ? AND password = ?',
      [email, password],
    );
    return res.isNotEmpty ? true : false;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Encryption key (used for encrypting and decrypting password)
  final _key = encrypt.Key.fromLength(32); // 32 bytes key for AES-256 encryption
  final _iv = encrypt.IV.fromLength(16); // 16 bytes IV for AES encryption

  // Encrypt password before saving to models
  String encryptPassword(String password) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(password, iv: _iv);
    return encrypted.base64; // Return encrypted password as base64
  }

  // Decrypt password when fetching from models
  String decryptPassword(String encryptedPassword) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decrypt64(encryptedPassword, iv: _iv);
    return decrypted;
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

  // CRUD for Friends

  Future<int> addFriend(Map<String, dynamic> friendship) async {
    final db = await database;
    return await db.insert('friends', friendship);
  }

  Future<List<Map<String, dynamic>>> getFriends(int userId) async {
    final db = await database;
    return await db.query('friends', where: 'user_id = ?', whereArgs: [userId]);
  }

  // Example Delete methods for each table
  Future<int> deleteUser(int userId) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }

  Future<int> deleteEvent(int eventId) async {
    final db = await database;
    return await db.delete('events', where: 'id = ?', whereArgs: [eventId]);
  }

  Future<int> deleteGift(int giftId) async {
    final db = await database;
    return await db.delete('gifts', where: 'id = ?', whereArgs: [giftId]);
  }

  Future<int> deleteFriend(int userId, int friendId) async {
    final db = await database;
    return await db.delete('friends',
        where: 'user_id = ? AND friend_id = ?', whereArgs: [userId, friendId]);
  }
}
