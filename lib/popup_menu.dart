import 'package:flutter/material.dart';
import 'presentation/screens/home.dart';
import 'presentation/screens/settings.dart';
import 'presentation/screens/services.dart';
import 'presentation/screens/resultados.dart';

class PopUpMenu extends StatefulWidget {
  const PopUpMenu({super.key, this.onlyHome = false});
  final bool onlyHome;

  @override
  State<PopUpMenu> createState() => _PopUpMenuState();
}

class _PopUpMenuState extends State<PopUpMenu> {
  int _currentIndex = 0;
  late final List<Map<String, dynamic>> _screens;

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
    );
  }
}
