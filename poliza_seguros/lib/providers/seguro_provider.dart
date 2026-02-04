import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/seguro.dart';
import '../services/seguro_service.dart';

final seguroByAutomovilProvider = FutureProvider.family<Seguro, int>((
  ref,
  automovilId,
) async {
  return SeguroService.obtenerPorAutomovilId(automovilId);
});

final recalcularSeguroProvider = FutureProvider.family<Seguro, int>((
  ref,
  automovilId,
) async {
  return SeguroService.recalcular(automovilId);
});

final deleteSeguroProvider = FutureProvider.family<void, int>((
  ref,
  automovilId,
) async {
  await SeguroService.eliminar(automovilId);
});
