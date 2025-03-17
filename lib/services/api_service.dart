import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/user_model.dart';

class ApiService {
  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }

  Future<void> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${user.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": user.name,
        "gender": user.gender,
        "country": user.country,
        "address": user.address,
        "email": user.email,
        "numberPhone": user.numberPhone,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el usuario');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el usuario');
    }
  }

  Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": user.name,
        "gender": user.gender,
        "country": user.country,
        "address": user.address,
        "email": user.email,
        "numberPhone": user.numberPhone,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear el usuario');
    }
  }

}
