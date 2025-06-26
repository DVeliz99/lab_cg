class ParameterResult {
  final String nombre;
  final List<String> setValue;
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
      setValue: List<String>.from(map['set_value'] ?? []),
      unidades: map['unidades'],
      valorReferencia: map['valor_referencia'],
    );
  }

  @override
  String toString() {
    return 'ParameterResult(nombre: $nombre, setValue: $setValue, unidades: $unidades, valorReferencia: $valorReferencia)';
  }
}
