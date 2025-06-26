import 'package:flutter/material.dart';
import 'package:lab_cg/data/firebase_data_sources/firebase_auth_data_source.dart';
import 'package:lab_cg/data/implements/auth_repository_impl.dart';
import 'package:lab_cg/presentation/screens/home.dart';
import 'package:lab_cg/presentation/screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab_cg/use_cases/auth_use_cases.dart';

class PopUpMenu extends StatefulWidget {
  final bool onlyHome;
  const PopUpMenu({super.key, this.onlyHome = false});

  @override
  State<PopUpMenu> createState() => _PopUpMenuState();
}

class _PopUpMenuState extends State<PopUpMenu> {
  int _currentIndex = 0;

  late List<Map<String, dynamic>> _screens;
  late final LogoutUseCase _logoutUseCase;

  void _initAuthLogoutUseCase() async {
    // Instancia de FirebaseAuth
    final firebaseAuth = FirebaseAuth.instance;

    final authDataSource = FirebaseAuthDataSource(firebaseAuth);

    // Repositorio con la data source
    final authRepository = AuthRepositoryImpl(authDataSource);

    // Caso de uso con el repositorio
    _logoutUseCase = LogoutUseCase(authRepository);
  }

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

    _initAuthLogoutUseCase();
  }

  void _submitLogout() async {
    try {
      await _logoutUseCase.call();
      _gotToLogin();
      print("Sesión cerrada correctamente");
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  void _goHome() {
    setState(() {
      _currentIndex = 0;
    });
  }

  void _gotToLogin() {
    Navigator.pushNamed(context, 'init');
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
                _submitLogout();
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
