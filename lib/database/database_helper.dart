import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init() {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = kIsWeb ? '' : await getDatabasesPath();
    final path = kIsWeb ? filePath : join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        lastName TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        position TEXT,
        description TEXT,
        website TEXT,
        facebook TEXT,
        instagram TEXT,
        linkedin TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Inserir usuário admin padrão
    await db.insert('users', {
      'name': 'Admin',
      'lastName': 'Sistema',
      'email': 'admin@email.com',
      'password': 'admin123',
      'role': 'admin',
      'position': 'Administrador',
      'description': 'Usuário administrador do sistema',
      'website': '',
      'facebook': '',
      'instagram': '',
      'linkedin': '',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // Criar novo usuário
  Future<User> createUser(User user) async {
    final db = await database;
    final id = await db.insert('users', user.toMap());
    return user.copyWith(id: id);
  }

  // Buscar usuário por ID
  Future<User?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Buscar usuário por email
  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Buscar todos os usuários
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final maps = await db.query('users', orderBy: 'name ASC');
    return maps.map((map) => User.fromMap(map)).toList();
  }

  // Atualizar usuário
  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Deletar usuário
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Verificar se email já existe
  Future<bool> emailExists(String email, {int? excludeId}) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: excludeId != null ? 'email = ? AND id != ?' : 'email = ?',
      whereArgs: excludeId != null ? [email, excludeId] : [email],
    );
    return maps.isNotEmpty;
  }

  // Autenticar usuário
  Future<User?> authenticate(String email, String password) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Fechar banco de dados
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
