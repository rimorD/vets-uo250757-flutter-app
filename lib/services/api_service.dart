import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vets_uo250757_flutter_app/src/user.dart';

class ApiService {
  // Emulador Android usa 10.0.2.2 para llegar al localhost de la máquina host.
  // Cambiar a la IP local del equipo para usar en dispositivo físico.
  static const String _baseUrl = 'http://10.0.2.2:8080';
  static String? _token;

  static void setToken(String token) => _token = token;
  static void clearToken() => _token = null;

  static Map<String, String> get _authHeaders => {
    'Content-Type': 'application/json',
    'token': _token ?? '',
  };

  static void _checkAuth(http.Response response) {
    if (response.statusCode == 401) {
      clearToken();
      throw UnauthorizedException();
    }
  }

  static String _parseError(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is List && decoded.isNotEmpty) {
        return decoded.first.values.first.toString();
      }
      if (decoded is Map && decoded.containsKey('message')) {
        return decoded['message'].toString();
      }
    } catch (_) {}
    return body.isNotEmpty ? body : 'Error desconocido';
  }

  static Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['token'] as String;
    }
    throw Exception('Credenciales inválidas');
  }

  static Future<List<User>> getUsers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users'),
      headers: _authHeaders,
    );
    _checkAuth(response);
    final List<dynamic> body = jsonDecode(response.body);
    return body
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/signUp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception(_parseError(response.body));
    }
  }

  static Future<void> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/users/${user.id}'),
      headers: _authHeaders,
      body: jsonEncode(user.toJson()),
    );
    _checkAuth(response);
    if (response.statusCode != 200) {
      throw Exception(_parseError(response.body));
    }
  }

  static Future<void> deleteUser(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/users/$id'),
      headers: _authHeaders,
    );
    _checkAuth(response);
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el usuario');
    }
  }
}

class UnauthorizedException implements Exception {}
