import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:lab_cg/data/firebase_data_sources/firebase_auth_data_source.dart';
import 'package:lab_cg/data/firebase_data_sources/firebase_user_data_source.dart';
import 'package:lab_cg/data/implements/auth_repository_impl.dart';
import 'package:lab_cg/data/implements/user_repository_impl.dart';
import 'package:lab_cg/domain/auth.dart';

import 'package:lab_cg/domain/service.dart';
import 'package:lab_cg/domain/user.dart';
import 'package:lab_cg/use_cases/auth_use_cases.dart';
import 'package:lab_cg/use_cases/user_use_cases.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class AppointmentFormScreen extends StatefulWidget {
  final Service service;
  const AppointmentFormScreen({super.key, required this.service});

  @override
  State<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _sending = false;
  String? currentUserUid;
  bool userReady = false;

  late final GetCurrentUserUseCase _getCurrentUser;
  late final GetUserByUidUseCase _getUserByUid;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //Tipo modelos
  Auth? authUser;
  AppUser? currentUserAuthenticated;

  @override
  void initState() {
    super.initState();
    _initGetCurrentUserUseCase();
    _initGetUserByUidUseCase();
    _initializeNotifications();
    _requestNotificationPermission();

    Future.microtask(() async {
      //segura obtener el usuario antes de cargar valores
      await _getCurrentUserUidLoggedIn();
      await _getCurrentUserLoggedIn(currentUserUid!);
    });
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Crear el canal de notificación en Android 8.0+
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'appointment_channel', // id del canal, debe coincidir con el usado en _showNotification
      'Citas', // nombre visible para el usuario
      description: 'Notificaciones de citas agendadas',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.request().isGranted) {
      print("Permiso de notificación concedido");
    } else {
      print("Permiso de notificación denegado");
    }
  }

  Future<void> _submit() async {
    debugPrint('Se ejecutó _submit');

    if (_selectedDate == null || _selectedTime == null) return;

    setState(() => _sending = true);

    final user = FirebaseAuth.instance.currentUser!;
    final start = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    // Crear referencia con ID automático
    final docRef = FirebaseFirestore.instance.collection('appoinments').doc();
    final docId = docRef.id;

    await docRef.set({
      'uid': docId, // Agregamos el ID como campo
      'uid_user': user.uid,
      'uid_service': widget.service.uid,
      'service_name': widget.service.name,
      'start_at': start,
      'created_at': FieldValue.serverTimestamp(),
    });

    // Mostrar notificación local

    if (currentUserAuthenticated != null &&
        currentUserAuthenticated!.notifications != null &&
        currentUserAuthenticated!.notifications!) {
      await _showNotification(widget.service.name, start);
    } else {
      print('currentUserAuthenticated es null');
    }

    if (mounted) {
      setState(() => _sending = false);
      Navigator.pop(context);
    }
  }

  Future<void> _showNotification(String serviceName, DateTime start) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'appointment_channel', // id del canal
          'Citas', // nombre del canal
          channelDescription: 'Notificaciones de citas agendadas',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    // Formatea la fecha para mostrar en la notificación
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(start);

    await flutterLocalNotificationsPlugin.show(
      0, // id de la notificación (puedes hacer un id dinámico si quieres)
      'Cita agendada',
      'Tu cita para "$serviceName" fue agendada para $formattedDate',
      platformDetails,
    );
  }

  void _initGetCurrentUserUseCase() async {
    // Instancia de FirebaseAuth
    final firebaseAuth = FirebaseAuth.instance;

    // Instancia concreta de data source
    final authDataSource = FirebaseAuthDataSource(firebaseAuth);

    // Repositorio con la data source
    final authRepository = AuthRepositoryImpl(authDataSource);

    _getCurrentUser = GetCurrentUserUseCase(authRepository);
  }

  void _initGetUserByUidUseCase() {
    final userDataSource = FirebaseUserDataSource();
    final userRepository = UserRepositoryImpl(userDataSource);
    _getUserByUid = GetUserByUidUseCase(userRepository);
  }

  Future<String> _getCurrentUserUidLoggedIn() async {
    final result = await _getCurrentUser.call();
    if (result.isSuccess) {
      setState(() {
        currentUserUid = result.data!.uid;
        authUser = result.data!;
      });

      print('El usuario autenticado actualmente es: $authUser');

      return currentUserUid ?? 'No se encontró el usuario';
    } else {
      return 'Fallo al obtener usuario: ${result.failure?.message}';
    }
  }

  Future<AppUser?> _getCurrentUserLoggedIn(String uid) async {
    if (uid.isNotEmpty) {
      final result = await _getUserByUid.call(uid);
      if (result.isSuccess && result.data != null) {
        setState(() {
          currentUserAuthenticated = result.data!;
          userReady = true;
        });

        print(
          'El usuario actualmente autenticado es: $currentUserAuthenticated',
        );
        return currentUserAuthenticated;
      } else {
        print(
          'Fallo al obtener usuario: ${result.failure?.message ?? "El documento no existe"}',
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt =
        _selectedDate != null
            ? DateFormat.yMMMEd('es').format(_selectedDate!)
            : 'Elegir fecha';
    final timeFmt =
        _selectedTime != null ? _selectedTime!.format(context) : 'Elegir hora';

    return Scaffold(
      appBar: AppBar(title: const Text('Agendar cita')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  widget.service.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    dateFmt,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialDate: DateTime.now(),
                      locale: const Locale('es'),
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.access_time_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    timeFmt,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) setState(() => _selectedTime = picked);
                  },
                ),
                const Spacer(),
                ElevatedButton.icon(
                  icon:
                      _sending
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.check),
                  label: const Text('Confirmar'),
                  onPressed: (_sending || !userReady) ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
