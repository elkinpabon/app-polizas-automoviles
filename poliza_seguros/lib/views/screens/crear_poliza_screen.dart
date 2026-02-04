import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/propietario_provider.dart';
import '../../providers/automovil_provider.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_theme.dart';
import 'detalle_automovil_screen.dart';

class CrearPolizaScreen extends ConsumerStatefulWidget {
  const CrearPolizaScreen({super.key});

  @override
  ConsumerState<CrearPolizaScreen> createState() => _CrearPolizaScreenState();
}

class _CrearPolizaScreenState extends ConsumerState<CrearPolizaScreen> {
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  final _valorController = TextEditingController();
  final _accidentesController = TextEditingController();

  String? _modeloSeleccionado = 'A';
  String? _edadSeleccionada = '18-24';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Póliza'),
        elevation: 0,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección Propietario
            _buildSectionHeader('Información del Propietario'),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _nombreController,
              label: 'Nombre Completo',
              icon: Icons.person,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _edadController,
              label: 'Edad',
              icon: Icons.cake,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Sección Automóvil
            _buildSectionHeader('Información del Automóvil'),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _valorController,
              label: 'Valor del Automóvil (\$)',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Modelo de Auto
            Text('Modelo del Automóvil', style: AppTheme.sectionTitleStyle),
            const SizedBox(height: 8),
            ..._buildRadioGroup(['A', 'B', 'C'], (value) {
              setState(() => _modeloSeleccionado = value);
            }, _modeloSeleccionado),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _accidentesController,
              label: 'Número de Accidentes',
              icon: Icons.warning_rounded,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            // Sección Edad del Propietario
            _buildSectionHeader('Rango de Edad'),
            const SizedBox(height: 8),
            ..._buildAgeRadioGroup(),
            const SizedBox(height: 32),

            // Botón Crear Póliza
            SizedBox(
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: _isLoading ? null : _crearPoliza,
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'CREAR PÓLIZA',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  List<Widget> _buildRadioGroup(
    List<String> options,
    Function(String) onChanged,
    String? selected,
  ) {
    return options.map((option) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: RadioListTile<String>(
          title: Text(
            'Modelo $option',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          value: option,
          groupValue: selected,
          activeColor: AppColors.primary,
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      );
    }).toList();
  }

  List<Widget> _buildAgeRadioGroup() {
    final ageRanges = [
      ('18-24', 'Mayor igual a 18 y menor a 24'),
      ('24-53', 'Mayor igual a 24 y menor a 53'),
      ('53+', 'Mayor igual a 55'),
    ];
    return ageRanges.map((rangeInfo) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: RadioListTile<String>(
          title: Text(
            rangeInfo.$2,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          value: rangeInfo.$1,
          groupValue: _edadSeleccionada,
          activeColor: AppColors.primary,
          onChanged: (value) {
            setState(() => _edadSeleccionada = value);
          },
        ),
      );
    }).toList();
  }

  void _crearPoliza() async {
    if (_nombreController.text.isEmpty ||
        _edadController.text.isEmpty ||
        _valorController.text.isEmpty ||
        _accidentesController.text.isEmpty) {
      _showSnackBar('Por favor completa todos los campos', isError: true);
      return;
    }

    final edadInt = int.tryParse(_edadController.text);
    if (edadInt == null || edadInt < 18) {
      _showSnackBar('La edad debe ser mayor o igual a 18 años', isError: true);
      return;
    }

    final valorDouble = double.tryParse(_valorController.text);
    if (valorDouble == null || valorDouble <= 0) {
      _showSnackBar('El valor debe ser un número mayor a 0', isError: true);
      return;
    }

    final accidentesInt = int.tryParse(_accidentesController.text);
    if (accidentesInt == null || accidentesInt < 0) {
      _showSnackBar('El número de accidentes debe ser 0 o más', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Crear propietario
      final propietarioResult = await ref.read(
        crearPropietarioProvider((_nombreController.text, edadInt)).future,
      );

      // Crear automóvil
      final automovilCreado = await ref.read(
        crearAutomovilProvider((
          modelo: _modeloSeleccionado ?? 'A',
          valor: valorDouble,
          accidentes: accidentesInt,
          propietarioId: propietarioResult.id!,
        )).future,
      );

      _showSnackBar('¡Póliza creada exitosamente!', isError: false);

      if (mounted) {
        // Navegar a detalle sin hacer refresh que causa loop infinito
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetalleAutomovilScreen(automovil: automovilCreado),
          ),
        );
      }
    } catch (e) {
      _showSnackBar('Error: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _valorController.dispose();
    _accidentesController.dispose();
    super.dispose();
  }
}
