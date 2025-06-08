import 'package:flutter/material.dart';
import 'package:lab_cg/presentation/screens/home.dart';
import 'package:lab_cg/presentation/screens/login.dart';
import '/use_cases/auth_use_cases.dart';
//implementacion concreta

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  late final LogoutUseCase _logoutUseCase;

  @override
  void initState() {
    super.initState();

    // Crear la instancia concreta del DataSource
    // final authDataSource = FirebaseAuthDataSource(FirebaseAuth.instance);
    // final authRepository = AuthRepositoryImpl(authDataSource);
    // _logoutUseCase = LogoutUseCase(authRepository);
  }

  final List<Map<String, dynamic>> _screens = [
    {"title": "Home", "screen": HomeScreen()},
    {
      "title": 'Logout',
      "action": null,
      "screen": Container(), // Evita error al acceder a `screen`
    },
    {"title": "Login", "screen": Login()},
  ];

  @override
  Widget build(BuildContext context) {
    // Actualizar la acción en build para poder usar _logoutUseCase (porque _screens es final)
    _screens[1]['action'] = () async {
      // await _logoutUseCase.call();
      // Después del logout se puede navegar a pantalla de login
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('init', (Route<dynamic> route) => false);
    };

    return Scaffold(
      body: _screens[_currentIndex]['screen'],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          final action = _screens[index]['action'];
          if (action != null) {
            action();
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Cerrar sesión',
          ),
        ],
      ),
    );
  }
}
