import 'package:flutter/material.dart';
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

  late List<Map<String, dynamic>> _screens;

  @override
  void initState() {
    super.initState();
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
