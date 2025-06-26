class ParameterResult {
  final String nombre;
  final List<double> setValue;
  final String? unidades;
  final String? valorReferencia;

  ParameterResult({
    required this.nombre,
    required this.setValue,
    this.unidades,
    this.valorReferencia,
  });

  factory ParameterResult.fromMap(Map<String, dynamic> map) {
    return ParameterResult(
      nombre: map['name'] ?? '',
      setValue: List<double>.from(
        (map['set_value'] ?? []).map((e) => e.toDouble()),
      ),
      unidades: map['unidades'],
      valorReferencia: map['valor_referencia'],
    );
  }
}
