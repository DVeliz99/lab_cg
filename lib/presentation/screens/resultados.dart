import 'package:flutter/material.dart';

class ResultadosScreen extends StatefulWidget {
  const ResultadosScreen({super.key});

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  void _goToAppController(BuildContext context) {
    Navigator.pushNamed(context, 'app-controller');
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double baseTextSize = screenWidth * 0.03;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        backgroundColor: Colors.white.withOpacity(0.8),
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Vuelve a la pantalla anterior
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'home') {
                _goToAppController(context);
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem<String>(
                    value: 'home',
                    child: Text('Home'),
                  ),
                ],
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visualización de resultados',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: baseTextSize * 2,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.white,
                          offset: Offset(-2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Icon(Icons.add_circle, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Resultados de Examen Médico',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: baseTextSize * 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "David Cruz Ramirez",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("ID: 678122"),
                          Text("Fecha del examen: 22 de mayo 2025"),
                          const SizedBox(height: 12),
                          Text(
                            "Hemograma Completo",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTable(),
                          const SizedBox(height: 12),
                          Text(
                            "Comentarios: Valores normales. No se observan anomalías",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800],
                              ),
                              onPressed: () {},
                              icon: Icon(
                                Icons.picture_as_pdf,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Descargar PDF",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTable() {
    final rows = [
      ["Glóbulos Rojos", "4.7 mill/µm", "4.7 - 5.4 mill/µm"],
      ["Hemoglobina", "13.5 g/dL", "12.0 - 15.5 g/dL"],
      ["Hematocrito", "41%", "36 - 46%"],
      ["Glóbulos Blancos", "6.500/µL", "4.000 - 11.000/µL"],
      ["Plaquetas", "250.000/µL", "150.000 - 400.000/µL"],
    ];

    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[300]),
          children: [
            _tableHeader("Parámetro"),
            _tableHeader("Resultado"),
            _tableHeader("Valores"),
          ],
        ),
        for (var row in rows)
          TableRow(
            children:
                row
                    .map(
                      (cell) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(cell),
                      ),
                    )
                    .toList(),
          ),
      ],
    );
  }

  Widget _tableHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
