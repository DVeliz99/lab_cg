import 'package:flutter/material.dart';
import 'presentation/screens/home.dart';
import 'presentation/screens/settings.dart';
import 'presentation/screens/services.dart';
import 'presentation/screens/resultados.dart';

class PopUpMenu extends StatefulWidget {
  const PopUpMenu({super.key, this.onlyHome = false});
  final bool onlyHome;
=======
import 'package:lab_cg/presentation/screens/home.dart';
import 'package:lab_cg/presentation/screens/settings.dart';

class PopUpMenu extends StatefulWidget {
  final bool onlyHome;
  const PopUpMenu({super.key, this.onlyHome = false});


  @override
  State<PopUpMenu> createState() => _PopUpMenuState();
}

class _PopUpMenuState extends State<PopUpMenu> {
  int _currentIndex = 0;

  late final List<Map<String, dynamic>> _screens;
=======

  late List<Map<String, dynamic>> _screens;


  @override
  void initState() {
    super.initState();

    _screens = widget.onlyHome
        ? [
            {"title": "Home", "screen": const HomeScreen()},
          ]
        : [
            {"title": "Home",       "screen": const HomeScreen()},
            {"title": "Servicios",  "screen": const ServiciosScreen()},
            {"title": "Resultados", "screen": const ResultadosScreen()},
            {"title": "Settings",   "screen": const SettingsScreen()},
          ];

    _screens =
        widget.onlyHome
            ? [
              {"title": "Home", "screen": HomeScreen()},
            ]
            : [
              {"title": "Home", "screen": HomeScreen()},
              {"title": "Settings", "screen": SettingsScreen()},
            ];
  }

  void _logout() {
    // await _logoutUseCase.call();
    Navigator.of(context).pushNamedAndRemoveUntil('init', (route) => false);
  }

  void _goHome() {
    setState(() {
      _currentIndex = 0;
    });
  }

  void _goSettings() {
    setState(() {
      _currentIndex = 1;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_currentIndex]['title'] as String),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context)
                .pushNamedAndRemoveUntil('init', (route) => false),
          ),
        ],
      ),
      body: _screens[_currentIndex]['screen'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.medical_services), label: 'Servicios'),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart), label: 'Resultados'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),

    final isHomeScreen = _currentIndex == 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_currentIndex]['title']),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              } else if (value == 'home') {
                _goHome();
              } else if (value == 'settings') {
                _goSettings();
              }
            },
            itemBuilder:
                (context) => [
                  if (isHomeScreen) ...[
                    const PopupMenuItem(
                      value: 'logout',
                      child: Text('Cerrar sesión'),
                    ),
                  ] else ...[
                    const PopupMenuItem(
                      value: 'home',
                      child: Text('Ir a Home'),
                    ),
                  ],
                ],
          ),
        ],
      ),
      body: _screens[_currentIndex]['screen'],

    );
  }
}
