import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double baseTextSize = screenWidth * 0.03;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ──────────────────── SALUDO ────────────────────
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Hola, John',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: baseTextSize * 2.5,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.white,
                                      offset: Offset(-3, 3),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Bienvenido a lab CG',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: baseTextSize * 1.5,
                              shadows: const [
                                Shadow(
                                  color: Colors.white,
                                  offset: Offset(-2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // ──────────────────── BOTONES ────────────────────
                      Padding(
                        padding: const  EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // Fila de Servicios e Historial
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // ──── Servicios ────
                                InkWell(
                                  onTap: () =>
                                      Navigator.of(context).pushNamed('servicios'),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: screenWidth * 0.42,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 16),
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.biotech,
                                            size: baseTextSize * 1.4),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Servicios',
                                          style: TextStyle(
                                            fontSize: baseTextSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // ──── Historial (Resultados) ────
                                InkWell(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed('resultados'),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: screenWidth * 0.42,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 16),
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.assignment,
                                            size: baseTextSize * 1.4),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Historial',
                                          style: TextStyle(
                                            fontSize: baseTextSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // ───────────────── Próxima Cita ─────────────────
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Próxima Cita',
                                    style: TextStyle(
                                      fontSize: baseTextSize * 1.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Viernes 6 de Junio',
                                    style: TextStyle(
                                      fontSize: baseTextSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Text('10:30 AM'),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          'Prueba: Hemograma Completo',
                                          style: TextStyle(
                                            fontSize: baseTextSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // ───────────────── CONFIGURACIÓN ─────────────────
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed('settings'),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.settings,
                                        size: baseTextSize * 1.4),
                                    Text(
                                      'Configuración',
                                      style: TextStyle(
                                        fontSize: baseTextSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward,
                                        size: baseTextSize * 1.4),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}