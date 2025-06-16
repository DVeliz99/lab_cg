import 'package:flutter/material.dart';

class ServiciosScreen extends StatelessWidget {
  const ServiciosScreen({super.key});

  /// Datos de demostración
  final List<Map<String, dynamic>> _servicios = const [
    {"nombre": "Consulta general",     "icono": Icons.medical_services_outlined},
    {"nombre": "Laboratorio clínico",  "icono": Icons.biotech_outlined},
    {"nombre": "Rayos X",              "icono": Icons.image_outlined},
    {"nombre": "Ultrasonido",          "icono": Icons.waves_outlined},
    {"nombre": "Farmacia",             "icono": Icons.local_pharmacy_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _servicios.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final s = _servicios[i]; // prueba
          return Card(
            elevation: 2,
            child: ListTile(
              leading: Icon(s['icono'] as IconData),
              title: Text(s['nombre'] as String),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                //A futuro
              },
            ),
          );
        },
      ),
    );
  }
}
