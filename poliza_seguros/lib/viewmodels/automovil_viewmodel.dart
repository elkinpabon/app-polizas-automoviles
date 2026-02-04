import 'package:flutter/material.dart';
import '../models/automovil.dart';
import '../services/automovil_service.dart';

class AutomovilViewModel extends ChangeNotifier {
  List<Automovil> automoviles = [];
  bool isLoading = false;
  String? error;

  Future<void> cargarAutomoviles() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      automoviles = await AutomovilService.obtenerTodos();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> crearAutomovil({
    required String modelo,
    required double valor,
    required int accidentes,
    required int propietarioId,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final creado = await AutomovilService.crear(
        modelo: modelo,
        valor: valor,
        accidentes: accidentes,
        propietarioId: propietarioId,
      );
      automoviles.add(creado);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> eliminarAutomovil(int id) async {
    try {
      await AutomovilService.eliminar(id);
      automoviles.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
