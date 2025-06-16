import 'package:flutter/material.dart';
import 'package:lab_cg/presentation/screens/settings.dart';
import 'package:lab_cg/presentation/screens/cita.dart';
import 'popup_menu.dart';
import 'presentation/screens/login.dart';

import 'package:lab_cg/presentation/screens/services.dart';
import 'package:lab_cg/presentation/screens/resultados.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: 'init',

  routes: {
    'init'          : (context) => Login(),
    'app-controller': (context) => PopUpMenu(),

    'settings'      : (context) => SettingsScreen(),
    'agendar-cita'  : (context) => const AgendarCitaScreen(),

    'servicios'     : (context) => const ServiciosScreen(),
    'resultados'    : (context) => const ResultadosScreen(),
  },

=======
      routes: {
        "init": (context) => Login(),
        "app-controller": (context) => PopUpMenu(),
        "settings": (context) => SettingsScreen(),
        "agendar-cita": (context) => const AgendarCitaScreen(),
      },

    );
  }
}

/*  // Inyección de dependencias
  final firestore = FirebaseFirestore.instance;
  final dataSource = FirebaseUserDataSource(firestore: firestore);
  final repository = UserRepositoryImpl(dataSource: dataSource);
   */

