import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/propietario_provider.dart';
import '../../providers/automovil_provider.dart';
import '../../themes/app_colors.dart';
import 'crear_poliza_screen.dart';
import 'detalle_automovil_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Póliza de Seguros'), elevation: 0),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Propietarios', icon: Icon(Icons.person)),
                Tab(text: 'Automóviles', icon: Icon(Icons.car_rental)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPropietariosTab(ref),
                  _buildAutomobilesTab(ref),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CrearPolizaScreen()),
          );
        },
        tooltip: 'Crear Póliza',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPropietariosTab(WidgetRef ref) {
    final propietariosAsync = ref.watch(propietariosProvider);

    return propietariosAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.danger,
              ),
              const SizedBox(height: 16),
              Text('Error: $error', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
      data: (propietarios) {
        if (propietarios.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 64,
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 16),
                const Text('No hay propietarios'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: propietarios.length,
          itemBuilder: (context, index) {
            final propietario = propietarios[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text(
                    propietario.nombreCompleto.isNotEmpty
                        ? propietario.nombreCompleto[0].toUpperCase()
                        : '?',
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
                title: Text(propietario.nombreCompleto),
                subtitle: Text('${propietario.edad} años'),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.danger,
                  ),
                  onPressed: () {
                    if (propietario.id != null) {
                      ref.read(deletePropietarioProvider(propietario.id!));
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAutomobilesTab(WidgetRef ref) {
    final automobilesAsync = ref.watch(automobilesProvider);

    return automobilesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.danger,
              ),
              const SizedBox(height: 16),
              Text('Error: $error', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
      data: (automoviles) {
        if (automoviles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.car_rental,
                  size: 64,
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 16),
                const Text('No hay automóviles'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: automoviles.length,
          itemBuilder: (context, index) {
            final automovil = automoviles[index];
            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetalleAutomovilScreen(automovil: automovil),
                    ),
                  ).then((_) {
                    // Refrescar datos cuando el usuario regresa
                    ref.invalidate(propietariosProvider);
                    ref.invalidate(automobilesProvider);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Modelo ${automovil.modelo}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${automovil.valor.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.danger,
                            ),
                            onPressed: () {
                              if (automovil.id != null) {
                                ref.read(
                                  deleteAutomovilProvider(automovil.id!),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Accidentes: ${automovil.accidentes}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              if (automovil.costoSeguro != null)
                                Text(
                                  'Seguro: \$${automovil.costoSeguro!.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
