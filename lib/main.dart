import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lab_cg/core/firebase_config.dart';
import 'package:lab_cg/presentation/screens/history.dart';
import 'package:lab_cg/presentation/screens/resultados.dart';
import 'package:lab_cg/presentation/screens/services.dart';
import 'package:lab_cg/presentation/screens/settings.dart';
import 'package:lab_cg/presentation/screens/cita.dart';
import 'package:lab_cg/presentation/widgets/no_appointments.dart';
import 'package:lab_cg/presentation/screens/login.dart';
import 'package:lab_cg/presentation/screens/profile.dart';
import 'popup_menu.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', 'ES'), Locale('en', 'US')],
      initialRoute: 'init',
      routes: {
        "init": (context) => Login(),
        "app-controller": (context) => PopUpMenu(),
        "settings": (context) => SettingsScreen(),
        "agendar-cita": (context) => const AgendarCitaScreen(),
        "profile": (context) => const ProfileScreen(),
        "services": (context) => const ServicesScreen(),
        "appoinment": (context) => const AgendarCitaScreen(),
        "history": (context) => const HistoryScreen(),
        "results": (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args == null || args is! String) {
            return NoAppointments(title: 'Resultados');
          }
          return ResultadosScreen(citaUid: args);
        },
      },
    );
  }
}

void listarIdsEnApp() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('parametters').get();
  print("📦 Lista de IDs que ve esta app:");
  for (final doc in snapshot.docs) {
    print("👉 ${doc.id}");
  }
}
