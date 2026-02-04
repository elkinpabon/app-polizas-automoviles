import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/automovil.dart';
import '../../models/propietario.dart';
import '../../services/propietario_service.dart';
import '../../themes/app_colors.dart';

class DetalleAutomovilScreen extends ConsumerWidget {
  final Automovil automovil;

  const DetalleAutomovilScreen({super.key, required this.automovil});

  // Método para calcular el costo por valor
  double _calcularCargoPorValor(double valor) {
    return valor * 0.035; // 3.5% del valor
  }

  // Método para calcular costo por modelo
  double _calcularCargoPorModelo(double valor) {
    final porcentajes = {'A': 0.011, 'B': 0.012, 'C': 0.015};
    final porcentaje = porcentajes[automovil.modelo] ?? 0.011;
    return valor * porcentaje;
  }

  // Método para calcular costo por edad
  double _calcularCargoPorEdad(int edad) {
    if (edad >= 18 && edad < 24) {
      return 360;
    } else if (edad >= 24 && edad < 53) {
      return 240;
    } else if (edad >= 53) {
      return 430;
    }
    return 360;
  }

  // Método para calcular costo por accidentes
  double _calcularCargoPorAccidentes(int accidentes) {
    if (accidentes == 0) {
      return 0.0;
    } else if (accidentes <= 3) {
      return (17 * accidentes).toDouble();
    } else {
      // $17 por los primeros 3, luego $21 por cada adicional
      return ((17 * 3) + (21 * (accidentes - 3))).toDouble();
    }
  }

  // Calcular costo total
  double _calcularCostoTotal(int edad) {
    final cargoPorValor = _calcularCargoPorValor(automovil.valor);
    final cargoPorModelo = _calcularCargoPorModelo(automovil.valor);
    final cargoPorEdad = _calcularCargoPorEdad(edad);
    final cargoPorAccidentes = _calcularCargoPorAccidentes(
      automovil.accidentes,
    );

    return cargoPorValor + cargoPorModelo + cargoPorEdad + cargoPorAccidentes;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Seguro'),
        elevation: 0,
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder<Propietario>(
        future: PropietarioService.obtenerPorId(automovil.propietarioId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final propietario = snapshot.data;
          if (propietario == null) {
            return const Center(child: Text('Propietario no encontrado'));
          }
          final costoTotal = _calcularCostoTotal(propietario.edad);
          final cargoPorValor = _calcularCargoPorValor(automovil.valor);
          final cargoPorModelo = _calcularCargoPorModelo(automovil.valor);
          final cargoPorEdad = _calcularCargoPorEdad(propietario.edad);
          final cargoPorAccidentes = _calcularCargoPorAccidentes(
            automovil.accidentes,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección: Información del Propietario
                _buildSectionCard(
                  title: 'Información del Propietario',
                  child: Column(
                    children: [
                      _buildInfoRow('Nombre:', propietario.nombreCompleto),
                      const SizedBox(height: 12),
                      _buildInfoRow('Edad:', '${propietario.edad} años'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Sección: Información del Automóvil
                _buildSectionCard(
                  title: 'Información del Automóvil',
                  child: Column(
                    children: [
                      _buildInfoRow('Modelo:', automovil.modelo),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Valor del Auto:',
                        '\$${automovil.valor.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Número de Accidentes:',
                        '${automovil.accidentes}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Sección: Desglose de Costos
                _buildCostBreakdownCard(
                  cargoPorValor: cargoPorValor,
                  cargoPorModelo: cargoPorModelo,
                  cargoPorEdad: cargoPorEdad,
                  cargoPorAccidentes: cargoPorAccidentes,
                  costoTotal: costoTotal,
                ),
                const SizedBox(height: 20),

                // Sección: Costo Total
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF0277BD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'COSTO TOTAL DE LA PÓLIZA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '\$${costoTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Botón Cerrar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildCostBreakdownCard({
    required double cargoPorValor,
    required double cargoPorModelo,
    required double cargoPorEdad,
    required double cargoPorAccidentes,
    required double costoTotal,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Desglose de Costos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildCostRow('Cargo por Valor (3.5%)', cargoPorValor),
            const SizedBox(height: 12),
            _buildCostRow(
              'Cargo por Modelo ${automovil.modelo}',
              cargoPorModelo,
            ),
            const SizedBox(height: 12),
            _buildCostRow('Cargo por Edad', cargoPorEdad),
            const SizedBox(height: 12),
            _buildCostRow('Cargo por Accidentes', cargoPorAccidentes),
            const Divider(height: 24, thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SUBTOTAL:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  '\$${costoTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.text),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
