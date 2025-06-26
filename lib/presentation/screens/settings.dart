import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab_cg/data/firebase_data_sources/firebase_auth_data_source.dart';
import 'package:lab_cg/data/firebase_data_sources/firebase_user_data_source.dart';
import 'package:lab_cg/data/implements/auth_repository_impl.dart';
import 'package:lab_cg/data/implements/user_repository_impl.dart';
import 'package:lab_cg/domain/auth.dart';
import 'package:lab_cg/domain/user.dart';
import 'package:lab_cg/presentation/widgets/toggle.dart';
import 'package:lab_cg/presentation/widgets/divider.dart';
import 'package:lab_cg/use_cases/auth_use_cases.dart';
import 'package:lab_cg/use_cases/user_use_cases.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String? currentUserUid;

  //Tipo modelos
  Auth? authUser;
  AppUser? currentUserAuthenticated;
  AppUser? currentUserData;

  //Casos de uso
  late final GetUserByUidUseCase _getUserByUid;
  late final GetCurrentUserUseCase _getCurrentUser;
  late final SetNotificationUseCase _setNotifications;
  late final SetContactMethodUseCase _setContactMethod;

  @override
  void initState() {
    super.initState();

    _initGetCurrentUserUseCase();
    _initGetUserByUidUseCase();
    _initSetNotificationUseCase();
    _initSetContactMethodUseCase();
    Future.microtask(() async {
      //segura obtener el usuario antes de cargar valores
      await _getCurrentUserUidLoggedIn();
      await cargarValores();
    });
  }

  void _initGetUserByUidUseCase() {
    final userDataSource = FirebaseUserDataSource();
    final userRepository = UserRepositoryImpl(userDataSource);
    _getUserByUid = GetUserByUidUseCase(userRepository);
  }

  void _initSetNotificationUseCase() {
    final userDataSource = FirebaseUserDataSource();
    final userRepository = UserRepositoryImpl(userDataSource);
    _setNotifications = SetNotificationUseCase(userRepository);
  }

  void _initSetContactMethodUseCase() {
    final userDataSource = FirebaseUserDataSource();
    final userRepository = UserRepositoryImpl(userDataSource);
    _setContactMethod = SetContactMethodUseCase(userRepository);
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

  void _goToAppController(BuildContext context) {
    Navigator.pushNamed(context, 'app-controller');
  }

  void _goToProfile(BuildContext context) {
    Navigator.pushNamed(context, 'profile');
  }

  Future<void> openPrivacyWeb() async {
    final Uri url = Uri.parse('https://privacyanddataprocessing.netlify.app/');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  Future<void> cargarValores() async {
    final result = await _getUserByUid.call(currentUserUid!);
    if (result.isSuccess) {
      currentUserData = result.data;
    } else {
      print('Error fetching user data: ${result.failure?.message}');
    }
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      notificaciones = currentUserData?.notifications ?? false;
      llamadas = currentUserData?.contactMethod == 'phone' ? true : false;
      mensajes = currentUserData?.contactMethod == 'messages' ? true : false;
    });
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

  Future<void> setNotification(bool valor) async {
    if (currentUserUid == null) {
      print('Error: UID del usuario es null.');
      return;
    }

    try {
      print(
        'Enviando valor "$valor" a la colección users para el usuario $currentUserUid...',
      );
      await _setNotifications.call(currentUserUid!, valor);
      print('Notificación actualizada correctamente.');
    } catch (e) {
      print('Error al actualizar la notificación: $e');
    }
  }

  Future<void> setContactMethod(String contactMethod) async {
    if (!mensajes && !llamadas) {
      if (currentUserUid == null) {
        print('Error: UID del usuario es null.');
        return;
      }

      try {
        print(
          'Enviando metodo de contacto "$contactMethod" a la colección users para el usuario $currentUserUid...',
        );
        await _setContactMethod.call(currentUserUid!, 'none');
        print('metodo de contacto actualizado correctamente a none.');
      } catch (e) {
        print('Error al actualizar el metodo de contacto: $e');
      }
    } else {
      if (currentUserUid == null) {
        print('Error: UID del usuario es null.');
        return;
      }

      try {
        print(
          'Enviando metodo de contacto "$contactMethod" a la colección users para el usuario $currentUserUid...',
        );
        await _setContactMethod.call(currentUserUid!, contactMethod);
        print('metodo de contacto actualizado correctamente.');
      } catch (e) {
        print('Error al actualizar el metodo de contacto: $e');
      }
    }
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
                                            await setNotification(nuevo);
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
                                                'llamadas',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              ToggleIcon(
                                                isOn: llamadas,
                                                onToggle: () async {
                                                  final nuevo = !llamadas;
                                                  setState(() {
                                                    llamadas = nuevo;
                                                    mensajes = false;
                                                  });
                                                  await setContactMethod(
                                                    'phone',
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
                                                    llamadas = false;
                                                  });
                                                  await setContactMethod(
                                                    'messages',
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
                                  GestureDetector(
                                    onTap:
                                        openPrivacyWeb, // 👉 Llama a tu función cuando se toca
                                    child: Padding(
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
