class Seguro {
  final int? id;
  final double costoTotal;
  final int automovilId;

  Seguro({this.id, required this.costoTotal, required this.automovilId});

  factory Seguro.fromJson(Map<String, dynamic> json) {
    return Seguro(
      id: json['id'],
      costoTotal: (json['costoTotal'] as num?)?.toDouble() ?? 0.0,
      automovilId: json['automovilId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'costoTotal': costoTotal, 'automovilId': automovilId};
  }
}
