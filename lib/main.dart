import 'package:flutter/material.dart';
import 'package:lab_cg/core/firebase_config.dart';
import 'package:lab_cg/presentation/screens/history.dart';
import 'package:lab_cg/presentation/screens/resultados.dart';
import 'package:lab_cg/presentation/screens/services.dart';
import 'package:lab_cg/presentation/screens/settings.dart';
import 'package:lab_cg/presentation/screens/cita.dart';
import 'popup_menu.dart';
import 'presentation/screens/login.dart';
import 'package:lab_cg/presentation/screens/profile.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ); // ícono de la notificación

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
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
      // 👇 Añade esto:
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        Locale('en', 'US'), // Inglés (puedes quitarlo si no lo usas)
      ],
      initialRoute: 'init',
      routes: {
        "init": (context) => Login(),
        "app-controller": (context) => PopUpMenu(),
        "settings": (context) => SettingsScreen(),
        "agendar-cita": (context) => const AgendarCitaScreen(),
        "profile": (context) => const ProfileScreen(),
        "results": (context) => const ResultadosScreen(),
        "services": (context) => const ServicesScreen(),
        "appoinment": (context) => const AgendarCitaScreen(),
        "history": (context) => const HistoryScreen(),
      },
    );
  }
}

/*  // Inyección de dependencias
  final firestore = FirebaseFirestore.instance;
  final dataSource = FirebaseUserDataSource(firestore: firestore);
  final repository = UserRepositoryImpl(dataSource: dataSource);
   */
