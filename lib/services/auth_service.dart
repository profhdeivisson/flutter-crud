import 'package:flutter/foundation.dart';

import '../database/database_helper.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // Login
  Future<bool> login(String email, String password) async {
    try {
      final user = await _dbHelper.authenticate(email, password);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Erro ao fazer login: $e');
      return false;
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Registrar novo usuário
  Future<bool> register(User user) async {
    try {
      // Verificar se email já existe
      final emailExists = await _dbHelper.emailExists(user.email);
      if (emailExists) {
        return false;
      }

      await _dbHelper.createUser(user);
      return true;
    } catch (e) {
      debugPrint('Erro ao registrar usuário: $e');
      return false;
    }
  }

  // Atualizar perfil do usuário atual
  Future<bool> updateCurrentUser(User updatedUser) async {
    try {
      await _dbHelper.updateUser(updatedUser);
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erro ao atualizar usuário: $e');
      return false;
    }
  }

  // Verificar se pode editar usuário
  bool canEditUser(int userId) {
    if (_currentUser == null) return false;
    return _currentUser!.isAdmin || _currentUser!.id == userId;
  }

  // Verificar se pode ver lista de usuários
  bool canViewUserList() {
    return _currentUser?.isAdmin ?? false;
  }
}
