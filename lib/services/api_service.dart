import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String apiKey = dotenv.env['API_KEY']!;
  final String baseUrl = dotenv.env['BASE_URL']!;

  Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('$baseUrl/'), headers: {"api_key": apiKey});

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
      headers: {"Content-Type": "application/json", "api_key": apiKey},
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
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {"api_key": apiKey},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el usuario');
    }
  }

  Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {"Content-Type": "application/json", "api_key": apiKey},
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

  Future<List<User>> searchUsers({String? country, String? gender}) async {
    final queryParams = <String, String>{};

    if (gender != null && gender.isNotEmpty) {
      if (gender.toLowerCase() == 'masculino') {
        queryParams['gender'] = 'male';
      } else if (gender.toLowerCase() == 'femenino') {
        queryParams['gender'] = 'female';
      } else {
        print('Género no válido recibido');
        return [];
      }
    }

    if (country != null && country.isNotEmpty) {
      queryParams['country'] = country;
    }

    final uri =
        Uri.parse('$baseUrl/search?').replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {"api_key": apiKey},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener usuarios');
    }
  }
}
