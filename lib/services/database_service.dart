// lib/services/database_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('taskflow_pro.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT DEFAULT '',
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt INTEGER NOT NULL,
        dueDate INTEGER,
        priority INTEGER NOT NULL DEFAULT 1,
        category INTEGER NOT NULL DEFAULT 0,
        hasReminder INTEGER NOT NULL DEFAULT 0,
        reminderTime INTEGER
      )
    ''');
  }

  // CREATE
  Future<Task> createTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toMap());
    return task;
  }

  // READ ALL
  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final result = await db.query('tasks', orderBy: 'createdAt DESC');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  // READ by ID
  Future<Task?> getTask(String id) async {
    final db = await database;
    final maps = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    }
    return null;
  }

  // UPDATE
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // DELETE
  Future<int> deleteTask(String id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // DELETE ALL COMPLETED
  Future<int> deleteCompletedTasks() async {
    final db = await database;
    return await db.delete('tasks', where: 'isCompleted = ?', whereArgs: [1]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
