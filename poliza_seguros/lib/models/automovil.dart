class Automovil {
  final int? id;
  final String modelo;
  final double valor;
  final int accidentes;
  final int propietarioId;
  final String? propietarioNombreC;
  final double? costoSeguro;
  final int? seguroId;

  Automovil({
    this.id,
    required this.modelo,
    required this.valor,
    required this.accidentes,
    required this.propietarioId,
    this.propietarioNombreC,
    this.costoSeguro,
    this.seguroId,
  });

  factory Automovil.fromJson(Map<String, dynamic> json) {
    return Automovil(
      id: json['id'],
      modelo: json['modelo'] ?? '',
      valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
      accidentes: json['accidentes'] ?? 0,
      propietarioId: json['propietarioId'] ?? 0,
      propietarioNombreC: json['propietarioNombreC'],
      costoSeguro: (json['costoSeguro'] as num?)?.toDouble(),
      seguroId: json['seguroId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modelo': modelo,
      'valor': valor,
      'accidentes': accidentes,
      'propietarioId': propietarioId,
    };
  }
}
