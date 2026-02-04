import 'package:flutter/material.dart';
import '../models/propietario.dart';
import '../services/propietario_service.dart';

class PropietarioViewModel extends ChangeNotifier {
  List<Propietario> propietarios = [];
  bool isLoading = false;
  String? error;

  Future<void> cargarPropietarios() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      propietarios = await PropietarioService.obtenerTodos();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> crearPropietario(String nombreCompleto, int edad) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final creado = await PropietarioService.crear(nombreCompleto, edad);
      propietarios.add(creado);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> eliminarPropietario(int id) async {
    try {
      await PropietarioService.eliminar(id);
      propietarios.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
