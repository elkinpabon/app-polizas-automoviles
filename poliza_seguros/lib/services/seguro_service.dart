import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/seguro.dart';

class SeguroService {
  static const String baseUrl = 'http://localhost:9090/bdd_dto/api/seguros';

  static Future<Seguro> obtenerPorAutomovilId(int automovilId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/automovil/$automovilId'),
      );

      if (response.statusCode == 200) {
        return Seguro.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Seguro no encontrado');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Seguro> recalcular(int automovilId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recalcular/$automovilId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Seguro.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al recalcular seguro');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<void> eliminar(int automovilId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/automovil/$automovilId'),
      );

      if (response.statusCode != 204) {
        throw Exception('Error al eliminar seguro');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
