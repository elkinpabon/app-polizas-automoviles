class Propietario {
  final int? id;
  final String nombreCompleto;
  final int edad;
  final List<int>? automovilIds;

  Propietario({
    this.id,
    required this.nombreCompleto,
    required this.edad,
    this.automovilIds,
  });

  factory Propietario.fromJson(Map<String, dynamic> json) {
    return Propietario(
      id: json['id'],
      nombreCompleto: json['nombreCompleto'] ?? '',
      edad: json['edad'] ?? 0,
      automovilIds: (json['automovilIds'] as List?)?.cast<int>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'nombreCompleto': nombreCompleto, 'edad': edad};
  }
}
