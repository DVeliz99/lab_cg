class Parameter {
  final String uid;
  final String name;
  final List<String> setValue;

  Parameter({required this.uid, required this.name, required this.setValue});

  // Método factory para crear desde un Map (por si quieres adaptar luego para Firestore)
  factory Parameter.fromMap(Map<String, dynamic> map) {
    return Parameter(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      setValue: List<String>.from(map['set_value'] ?? []),
    );
  }
}
