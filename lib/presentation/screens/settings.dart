import 'package:flutter/material.dart';
import 'package:lab_cg/presentation/widgets/toggle.dart';
import 'package:lab_cg/presentation/widgets/divider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificaciones = false;
  bool llamadas = false;
  bool mensajes = false;
  bool mostrarSubOpciones = false;

  @override
  void initState() {
    super.initState();
    cargarValores(); // Simula cargar desde base de datos
  }

  void _goToAppController(BuildContext context) {
    Navigator.pushNamed(context, 'app-controller');
  }

  void _goToProfile(BuildContext context) {
    Navigator.pushNamed(context, 'profile');
  }

  Future<void> cargarValores() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      notificaciones = true;
      llamadas = true;
      mensajes = false;
    });
  }

  Future<void> guardarEnBaseDeDatos(String tipo, bool valor) async {
    print('Guardando $tipo: $valor en base de datos...');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double baseTextSize = screenWidth * 0.03;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Título principal
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Configuración de la cuenta',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: baseTextSize * 2,
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

                        // Contenido
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  // Perfil
                                  // Perfil
                                  GestureDetector(
                                    onTap: () {
                                      _goToProfile(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.lock, size: 40),
                                          const SizedBox(width: 12),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              left: 11,
                                            ),
                                            child: const Text(
                                              'Perfil',
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const CustomDivider(),

                                  // Notificaciones
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.notifications,
                                          size: 40,
                                        ),
                                        const SizedBox(width: 12),
                                        const Expanded(
                                          child: Text(
                                            'Notificaciones',
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        ToggleIcon(
                                          isOn: notificaciones,
                                          onToggle: () async {
                                            final nuevo = !notificaciones;
                                            setState(() {
                                              notificaciones = nuevo;
                                            });
                                            await guardarEnBaseDeDatos(
                                              'notificaciones',
                                              nuevo,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  const CustomDivider(),

                                  // Método de contacto
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.contact_phone,
                                          size: 40,
                                        ),
                                        const SizedBox(width: 12),
                                        const Expanded(
                                          child: Text(
                                            'Método de\nContacto',
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            mostrarSubOpciones
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              mostrarSubOpciones =
                                                  !mostrarSubOpciones;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Subopciones
                                  if (mostrarSubOpciones)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Llamadas',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              ToggleIcon(
                                                isOn: llamadas,
                                                onToggle: () async {
                                                  final nuevo = !llamadas;
                                                  setState(() {
                                                    llamadas = nuevo;
                                                  });
                                                  await guardarEnBaseDeDatos(
                                                    'llamadas',
                                                    nuevo,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Mensajes',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              ToggleIcon(
                                                isOn: mensajes,
                                                onToggle: () async {
                                                  final nuevo = !mensajes;
                                                  setState(() {
                                                    mensajes = nuevo;
                                                  });
                                                  await guardarEnBaseDeDatos(
                                                    'mensajes',
                                                    nuevo,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  const CustomDivider(),

                                  // Acerca de
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info, size: 40),
                                        SizedBox(width: 12),
                                        Container(
                                          margin: EdgeInsets.only(left: 11),
                                          child: Text(
                                            'Acerca de',
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
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
                        ),
                      ],
                    ),
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
