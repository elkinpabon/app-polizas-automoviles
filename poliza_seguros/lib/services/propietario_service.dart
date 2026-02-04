import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/propietario.dart';

class PropietarioService {
  static const String baseUrl =
      'http://localhost:9090/bdd_dto/api/propietarios';

  static Future<Propietario> crear(String nombreCompleto, int edad) async {
    final propietario = Propietario(nombreCompleto: nombreCompleto, edad: edad);
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(propietario.toJson()),
      );

      if (response.statusCode == 201) {
        return Propietario.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al crear propietario: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<List<Propietario>> obtenerTodos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((p) => Propietario.fromJson(p)).toList();
      } else {
        throw Exception('Error al obtener propietarios');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Propietario> obtenerPorId(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return Propietario.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Propietario no encontrado');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Propietario> actualizar(int id, Propietario propietario) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(propietario.toJson()),
      );

      if (response.statusCode == 200) {
        return Propietario.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al actualizar propietario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<void> eliminar(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 204) {
        throw Exception('Error al eliminar propietario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
