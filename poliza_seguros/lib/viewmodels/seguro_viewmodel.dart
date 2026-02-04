import 'package:flutter/material.dart';
import '../models/seguro.dart';
import '../services/seguro_service.dart';

class SeguroViewModel extends ChangeNotifier {
  Seguro? seguro;
  bool isLoading = false;
  String? error;

  Future<void> obtenerSeguro(int automovilId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      seguro = await SeguroService.obtenerPorAutomovilId(automovilId);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recalcularSeguro(int automovilId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      seguro = await SeguroService.recalcular(automovilId);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
