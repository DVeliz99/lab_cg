import 'package:flutter/material.dart';

class NoAppointments extends StatelessWidget {
  final String title;

  const NoAppointments({super.key, required this.title});

  void _goToAppController(BuildContext context) {
    Navigator.pushNamed(context, 'app-controller');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white.withOpacity(0.8),
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'home') {
                _goToAppController(context);
              }
            },
            itemBuilder:
                (context) => const [
                  PopupMenuItem<String>(value: 'home', child: Text('Home')),
                ],
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/images/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Center(
              child: Text(
                'No hay resultados para esta cita',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                  shadows: [
                    Shadow(
                      color: Colors.white,
                      offset: Offset(-2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
