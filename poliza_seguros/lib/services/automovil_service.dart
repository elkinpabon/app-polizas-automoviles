import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/automovil.dart';

class AutomovilService {
  static const String baseUrl = 'http://localhost:9090/bdd_dto/api/automoviles';

  static Future<Automovil> crear({
    required String modelo,
    required double valor,
    required int accidentes,
    required int propietarioId,
  }) async {
    final automovil = Automovil(
      modelo: modelo,
      valor: valor,
      accidentes: accidentes,
      propietarioId: propietarioId,
    );
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(automovil.toJson()),
      );

      if (response.statusCode == 201) {
        return Automovil.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al crear automóvil: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<List<Automovil>> obtenerTodos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((a) => Automovil.fromJson(a)).toList();
      } else {
        throw Exception('Error al obtener automóviles');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Automovil> obtenerPorId(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return Automovil.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Automóvil no encontrado');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Automovil> actualizar(int id, Automovil automovil) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(automovil.toJson()),
      );

      if (response.statusCode == 200) {
        return Automovil.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al actualizar automóvil');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<void> eliminar(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 204) {
        throw Exception('Error al eliminar automóvil');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
