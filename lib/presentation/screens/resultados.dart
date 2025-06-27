import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:lab_cg/data/firebase_data_sources/firebase_auth_data_source.dart';

import 'package:lab_cg/data/firebase_data_sources/firebase_user_data_source.dart';
import 'package:lab_cg/data/firebase_data_sources/firebase_result_data_source.dart';
import 'package:lab_cg/data/firebase_data_sources/firebase_service_data_source.dart';

import 'package:lab_cg/data/implements/auth_repository_impl.dart';

import 'package:lab_cg/data/implements/user_repository_impl.dart';
import 'package:lab_cg/data/implements/result_repository_impl.dart';
import 'package:lab_cg/data/implements/service_repository_impl.dart';
import 'package:lab_cg/data/parametters_data.dart';

import 'package:lab_cg/domain/fullParameterData.dart';
import 'package:lab_cg/domain/parameter.dart';

import 'package:lab_cg/domain/user.dart';
import 'package:lab_cg/domain/result.dart';
import 'package:lab_cg/domain/service.dart';
import 'package:lab_cg/domain/parameter_result.dart';
import 'package:lab_cg/presentation/widgets/no_appointments.dart';

import 'package:lab_cg/use_cases/auth_use_cases.dart';

import 'package:lab_cg/use_cases/user_use_cases.dart';
import 'package:lab_cg/use_cases/result_use_cases.dart';
import 'package:lab_cg/use_cases/service_use_cases.dart';

class ResultadosScreen extends StatefulWidget {
  final String citaUid;

  const ResultadosScreen({super.key, required this.citaUid});

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  bool _isLoading = true;
  bool _showLoadingBeforeError = true;
  AppUser? currentUser;
  Result? result;
  Service? service;
  List<ParameterResult> parameters = [];
  late List<dynamic> paramsValue;
  List<FullParameterData> fullParameterData = [];

  late final GetCurrentUserUseCase _getCurrentUser;
  late final GetUserByUidUseCase _getUserByUid;
  late final GetResultByCitaUidUseCase _getResultByCitaUidUseCase;
  late final GetServiceByUid _getServiceByUid;

  final FirebaseResultDataSource _resultDataSource = FirebaseResultDataSource();

  @override
  void initState() {
    super.initState();
    _initUseCases();
    _loadData();

    // Si hay error en los datos, esperar 4s antes de mostrar el widget de error
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showLoadingBeforeError = false;
        });
      }
    });
  }

  void _initUseCases() {
    final resultRepository = ResultRepositoryImpl(_resultDataSource);

    _getCurrentUser = GetCurrentUserUseCase(
      AuthRepositoryImpl(FirebaseAuthDataSource(FirebaseAuth.instance)),
    );
    _getUserByUid = GetUserByUidUseCase(
      UserRepositoryImpl(FirebaseUserDataSource()),
    );
    _getResultByCitaUidUseCase = GetResultByCitaUidUseCase(resultRepository);
    _getServiceByUid = GetServiceByUid(
      ServiceRepositoryImpl(FirebaseServiceDataSource()),
    );
  }

  Future<List<FullParameterData>> getFullParameters(
    List<Map<String, dynamic>> paramsValue,
  ) async {
    final List<FullParameterData> results = [];

    for (final param in paramsValue) {
      final String id = param['id'];
      final String value = param['value'];

      try {
        final parameter = await getParameterByUid(id);
        if (parameter != null) {
          results.add(
            FullParameterData(
              id: id,
              name: parameter.name,
              setValue: parameter.setValue,
              value: value,
            ),
          );
        } else {
          print('No se encontró el parámetro con ID $id');
        }
      } catch (e) {
        print('Error al obtener datos para el parámetro con ID $id: $e');
      }
    }

    return results;
  }

  Future<void> _loadData() async {
    final authResult = await _getCurrentUser.call();
    final uid = authResult.data?.uid;
    if (uid == null) return;

    final userResult = await _getUserByUid.call(uid);
    final resultData = await _getResultByCitaUidUseCase.call(widget.citaUid);
    print('resultData en resultados screen $resultData');
    if (userResult.data == null || resultData == null) return;

    final serviceResult = await _getServiceByUid.call(
      resultData.uidService ?? '',
    );
    if (serviceResult.data == null) return;

    final paramsValueResult = await _resultDataSource
        .getSubcollectionParameters(
          resultData.uid!,
          resultData.uidService ?? '',
        );

    final parameterObjects = await getFullParameters(
      List<Map<String, dynamic>>.from(paramsValueResult),
    );

    setState(() {
      currentUser = userResult.data;
      result = resultData;
      service = serviceResult.data;
      paramsValue = paramsValueResult;
      fullParameterData = parameterObjects;
      _isLoading = false;
    });

    print('paramsValue $paramsValue');
  }

  Future<Parameter?> getParameterByUid(String uid) async {
    return _getParameterByUid(uid);
  }

  Parameter? _getParameterByUid(String uid) {
    try {
      return parametersList.firstWhere((param) => param.uid == uid);
    } catch (e) {
      return null; // No encontrado
    }
  }

  @override
  Widget build(BuildContext context) {
    if (result == null || service == null) {
      if (_showLoadingBeforeError) {
        return const Scaffold(
          backgroundColor: Colors.black87,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 20),
                Text(
                  'Buscando resultados...',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      } else {
        return const NoAppointments(title: 'Resultados');
      }
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double baseTextSize = screenWidth * 0.04; // Aumentado

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        backgroundColor: Colors.white.withOpacity(0.8),
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Visualización de resultados',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: baseTextSize * 1.8,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        color: Colors.white,
                        offset: Offset(-2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28), // 👈 esto lo baja

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 11, 102, 221),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resultados de',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.white,
                                offset: Offset(1, 1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Examen Médico',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.white,
                                offset: Offset(1, 1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser!.nombre ?? 'Nombre no disponible',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text("ID: ${currentUser!.uid}"),
                        Text(
                          "Fecha del examen: ${result!.createdAt?.toLocal().toString().split(' ')[0] ?? 'Fecha no disponible'}",
                        ),
                        const SizedBox(height: 12),
                        Text(
                          service!.name ?? 'Servicio no disponible',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(2),
                          },
                          border: TableBorder.all(color: Colors.black12),
                          children: [
                            const TableRow(
                              decoration: BoxDecoration(
                                color: Color(0xFFE0E0E0),
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Parámetro',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Valores',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Resultados',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ...fullParameterData.map((param) {
                              final setRange =
                                  param.setValue.length >= 2
                                      ? '${param.setValue[0]} - ${param.setValue[1]}'
                                      : param.setValue.join(' - ');
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(param.name),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(setRange),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(param.value),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Comentarios:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(result!.comment ?? 'Sin comentarios'),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[800],
                            ),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Descargar PDF",
                              style: TextStyle(color: Colors.white),
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
    );
  }
}
