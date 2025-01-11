import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../models/user_preferences.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'session_data.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE session (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            startTime TEXT,
            endTime TEXT,
            dataUsed INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE user_preferences (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userID TEXT,
            openVPN INTEGER,
            IPSec INTEGER,
            ISSR INTEGER,
            blockInternet INTEGER,
            connectOnStart INTEGER,
            showNotification INTEGER
          );
        ''');
      },
    );
  }

  Future<int> insertSession(String startTime, String endTime, int dataUsed) async {
    final db = await database;
    return await db.insert('session', {
      'startTime': startTime,
      'endTime': endTime,
      'dataUsed': dataUsed,
    });
  }

  Future<List<Map<String, dynamic>>> getSessions() async {
    final db = await database;
    return await db.query('session');
  }

  Future<Map<String, dynamic>?> getLastSession() async {
    final db = await database;
    final result = await db.query(
      'session',
      orderBy: 'id DESC',
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertUserPreferences(UserPreferences preferences) async {
    final db = await database;
    return await db.insert('user_preferences', preferences.toMap());
  }

  Future<UserPreferences?> getUserPreferences(String userID) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_preferences',
      where: 'userID = ?',
      whereArgs: [userID],
    );

    if (maps.isNotEmpty) {
      return UserPreferences.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUserPreferences(UserPreferences preferences) async {
    final db = await database;
    return await db.update(
      'user_preferences',
      preferences.toMap(),
      where: 'userID = ?',
      whereArgs: [preferences.userID],
    );
  }

  Future<int> getTotalDataUsed() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(dataUsed) as total FROM session');

    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    }
    return 0;
  }


}
