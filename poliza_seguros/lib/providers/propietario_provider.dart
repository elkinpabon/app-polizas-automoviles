import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/propietario.dart';
import '../services/propietario_service.dart';

final propietariosProvider = FutureProvider<List<Propietario>>((ref) async {
  return PropietarioService.obtenerTodos();
});

final propietarioByIdProvider = FutureProvider.family<Propietario, int>((
  ref,
  id,
) async {
  return PropietarioService.obtenerPorId(id);
});

final crearPropietarioProvider =
    FutureProvider.family<Propietario, (String, int)>((ref, params) async {
      return PropietarioService.crear(params.$1, params.$2);
    });

final deletePropietarioProvider = FutureProvider.family<void, int>((
  ref,
  id,
) async {
  await PropietarioService.eliminar(id);
  // Invalidate the list provider to refresh
  ref.invalidate(propietariosProvider);
});
