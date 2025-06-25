import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab_cg/data/firebase_data_sources/firebase_auth_data_source.dart';
import 'package:lab_cg/data/firebase_data_sources/firebase_cita_data_source.dart';
import 'package:lab_cg/data/firebase_data_sources/firebase_service_data_source.dart';
import 'package:lab_cg/data/firebase_data_sources/firebase_user_data_source.dart';
import 'package:lab_cg/data/implements/auth_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:lab_cg/data/implements/cita_repository_impl.dart';
import 'package:lab_cg/data/implements/service_repository_impl.dart';
import 'package:lab_cg/data/implements/user_repository_impl.dart';
import 'package:lab_cg/domain/auth.dart';
import 'package:lab_cg/domain/citas.dart';
import 'package:lab_cg/domain/service.dart';
import 'package:lab_cg/domain/user.dart';
import 'package:lab_cg/use_cases/auth_use_cases.dart';
import 'package:lab_cg/use_cases/cita_use_cases.dart';
import 'package:lab_cg/use_cases/service_use_cases.dart';
import 'package:lab_cg/use_cases/user_use_cases.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; //inicializar localizaciones



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //variables generales
  bool _isLoading = true;
  String? currentUserUid;
  late DateTime fecha;
  String? formattedDate;
  String? formattedTime;
  String? serviceUid;
  String? serviceName;

  //Intanscias de useCases
  late final GetUserByUidUseCase _getUserByUid;

  late final GetCurrentUserUseCase _getCurrentUser;

  late final GetCitaFromUserIdUseCase _getCitaFromUserId;

  late final GetServiceByUid _getServiceByuid;

  //Tipo modelos
  Auth? authUser;
  AppUser? currentUserAuthenticated;
  CitaLaboratorio? lastAppoinment;
  Service? service;

  @override
  void initState() {
    super.initState();
    initInstances();
    _loadUserData();
  }

  void initInstances() {
    _initGetCurrentUserUseCase();
    _initGetUserByUidUseCase();
    _initGetCitaFromUserIdUseCase();
    _initGetServiceByUid();
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

  void _initGetCitaFromUserIdUseCase() {
    final citaDataSource = FirebaseCitaDataSource();
    final citaRepository = CitasRepositoryImpl(citaDataSource);
    _getCitaFromUserId = GetCitaFromUserIdUseCase(citaRepository);
  }

  void _initGetServiceByUid() {
    final serviceDataSource = FirebaseServiceDataSource();
    final serviceRepository = ServiceRepositoryImpl(serviceDataSource);
    _getServiceByuid = GetServiceByUid(serviceRepository);
  }

  void _loadUserData() async {
    print('Cargando Data');
    final uid = await _getCurrentUserUidLoggedIn();
    if (uid.isNotEmpty && !uid.contains('Fallo')) {
      await _getCurrentUserLoggedIn(uid);
      await _getCitaByUserId(uid);

      if (lastAppoinment != null) {
        serviceUid = lastAppoinment?.uidService;

        if (serviceUid != null) {
          final serviceResult = await _getServiceByuid.call(serviceUid!);
          if (serviceResult.isSuccess) {
            serviceName = serviceResult.data?.name;
          } else {
            print(
              'Error al obtener el servicio: ${serviceResult.failure?.message}',
            );
          }
        }
      }
    }

    // Inicializar localización para fechas
    await initializeDateFormatting('es_ES', null);

    setState(() {
      _isLoading = false;
      fecha = lastAppoinment!.requestedAt;
      formattedDate = DateFormat("d 'de' MMMM 'de' y", 'es_ES').format(fecha);
      formattedTime = DateFormat("h:mm a", 'es_ES').format(fecha);
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

  Future<Service?> _getServiceByUid(String uid) async {
    final result = await _getServiceByuid.call(uid);
    if (result.isSuccess) {
      setState(() {
        service = result.data;
      });

      print('El servicio obtenido apartir de la cita es: $service');

      return service;
    } else {
      print('Fallo al obtener usuario: ${result.failure?.message}');
    }
    return null;
  }

  Future<CitaLaboratorio?> _getCitaByUserId(String uid) async {
    if (uid.isNotEmpty) {
      final result = await _getCitaFromUserId.call(uid);
      if (result.isSuccess && result.data != null) {
        setState(() {
          lastAppoinment = result.data!;
        });
        print('<============================================>');
        print('La cita obtenida es: $lastAppoinment');
        return lastAppoinment;
      } else {
        print(
          'Fallo al obtener cita: ${result.failure?.message ?? "El documento no existe"}',
        );
      }
    }
    return null;
  }

  Future<AppUser?> _getCurrentUserLoggedIn(String uid) async {
    if (uid.isNotEmpty) {
      final result = await _getUserByUid.call(uid);
      if (result.isSuccess && result.data != null) {
        setState(() {
          currentUserAuthenticated = result.data!;
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double baseTextSize = screenWidth * 0.03;
    if (_isLoading ||
        currentUserAuthenticated == null ||
        lastAppoinment == null ||
        formattedDate == null ||
        formattedTime == null ||
        serviceName == null) {
      // Mostrar una pantalla de carga mientras se obtiene la data para la pantalla home
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //saludo
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              // Semi-transparent background
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.transparent),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  width: double.infinity,
                                  margin: const EdgeInsetsDirectional.only(
                                    start: 30,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Hola, ${currentUserAuthenticated?.nombre}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize:
                                            baseTextSize *
                                            2.5, //tamaño de texto responsivo
                                        shadows: [
                                          Shadow(
                                            color: Colors.white,
                                            offset: Offset(-3, 3),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                  ),

                                  child: Center(
                                    child: Text(
                                      'Bienvenido a lab CG',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize:
                                            baseTextSize *
                                            1.5, // Responsive text size
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
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Botones
                      SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: screenWidth * 0.42,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.biotech, size: baseTextSize),
                                        SizedBox(width: 10),
                                        Text(
                                          'Servicios',
                                          style: TextStyle(
                                            fontSize: baseTextSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth * 0.42,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.assignment,
                                          size: baseTextSize,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Historial',
                                          style: TextStyle(
                                            fontSize: baseTextSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),

                              //  Cita
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Próxima Cita',
                                      style: TextStyle(
                                        fontSize: baseTextSize * 1.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '$formattedDate',
                                      style: TextStyle(
                                        fontSize: baseTextSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text('$formattedTime'),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            'Prueba: $serviceName',
                                            style: TextStyle(
                                              fontSize: baseTextSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Configuración
                              SizedBox(height: 20),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    print('Navigating to settings...');
                                    Navigator.pushNamed(context, 'settings');
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.settings, size: baseTextSize),
                                      Text(
                                        'Configuración',
                                        style: TextStyle(
                                          fontSize: baseTextSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: baseTextSize,
                                      ),
                                    ],
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
            );
          },
        ),
      ),
    );
  }
}


