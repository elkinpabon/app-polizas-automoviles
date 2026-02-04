import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/automovil.dart';
import '../services/automovil_service.dart';

final automobilesProvider = FutureProvider<List<Automovil>>((ref) async {
  return AutomovilService.obtenerTodos();
});

final crearAutomovilProvider =
    FutureProvider.family<
      Automovil,
      ({String modelo, double valor, int accidentes, int propietarioId})
    >((ref, params) async {
      return AutomovilService.crear(
        modelo: params.modelo,
        valor: params.valor,
        accidentes: params.accidentes,
        propietarioId: params.propietarioId,
      );
    });

final deleteAutomovilProvider = FutureProvider.family<void, int>((
  ref,
  id,
) async {
  await AutomovilService.eliminar(id);
  // Invalidate the list provider to refresh
  ref.invalidate(automobilesProvider);
});
