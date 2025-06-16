import 'package:flutter/material.dart';

class ResultadosScreen extends StatelessWidget {
  const ResultadosScreen({super.key});

  /// Datos de demostración
  final List<Map<String, String>> _fake = const [
    {"fecha": "2025-06-01", "prueba": "Hemograma completo", "estado": "Disponible"},
    {"fecha": "2025-05-28", "prueba": "Perfil lipídico",    "estado": "Disponible"},
    {"fecha": "2025-05-15", "prueba": "Glucosa en ayunas",  "estado": "Entregado"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: RefreshIndicator(
        onRefresh: () async {

          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _fake.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final r = _fake[i];
            return Card(
              elevation: 2,
              child: ListTile(
                title: Text(r['prueba']!),
                subtitle: Text('Fecha: ${r['fecha']}'),
                trailing: Text(
                  r['estado']!,
                  style: TextStyle(
                    color: r['estado'] == 'Disponible' ? Colors.green : Colors.grey,
                  ),
                ),
                onTap: () {
                //mostrar PDF o detalle del resultado. a futuro
                },
              ),
            );
          },
        ),
      ),
    );
  }
}