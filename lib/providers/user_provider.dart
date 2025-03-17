import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _apiService.fetchUsers();
    } catch (e) {
      _error = 'Error al cargar usuarios';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addUser(User user) async {
    try {
      await _apiService.createUser(user);
      _users.add(user);
      notifyListeners();
    } catch (e) {
      _error = 'Error al agregar usuario';
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _apiService.updateUser(user);
      int index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error al actualizar usuario';
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _apiService.deleteUser(id);
      _users.removeWhere((user) => user.id == id);
      notifyListeners();
    } catch (e) {
      _error = 'Error al eliminar usuario';
    }
  }
}
