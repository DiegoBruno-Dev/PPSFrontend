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

  Future<List<User>> searchUsers({String? country, String? gender}) async {
    final queryParams = <String, String>{};

    // Validación del género y ajuste del valor
    if (gender != null && gender.isNotEmpty) {
      if (gender.toLowerCase() == 'masculino') {
        queryParams['gender'] = 'male';
      } else if (gender.toLowerCase() == 'femenino') {
        queryParams['gender'] = 'female';
      } else {
        // Si el género no es válido
        print('Género no válido recibido');
        return [];
      }
    }

    // Si se proporciona un país, agregarlo a los parámetros
    if (country != null && country.isNotEmpty) {
      queryParams['country'] = country;
    }

    // Construcción de la URL con los parámetros de la consulta
    final uri =
        Uri.parse('$baseUrl/search?').replace(queryParameters: queryParams);

    // Log de la URL y parámetros
    print('URL de búsqueda: $uri');
    print('Parámetros enviados: $queryParams');

    final response = await http.get(uri);

    // Verificación de la respuesta del servidor
    print('Código de estado: ${response.statusCode}');
    print('Respuesta del servidor: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      // Si no es un estado 200, mostrar error
      throw Exception('Error al obtener usuarios');
    }
  }
}
