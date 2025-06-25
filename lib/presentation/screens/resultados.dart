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

import 'package:lab_cg/domain/user.dart';
import 'package:lab_cg/domain/result.dart';
import 'package:lab_cg/domain/service.dart';
import 'package:lab_cg/domain/parameter_result.dart';

import 'package:lab_cg/use_cases/auth_use_cases.dart';
import 'package:lab_cg/use_cases/user_use_cases.dart';
import 'package:lab_cg/use_cases/result_use_cases.dart';
import 'package:lab_cg/use_cases/service_use_cases.dart';

class ResultadosScreen extends StatefulWidget {
  const ResultadosScreen({super.key});

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  bool _isLoading = true;
  AppUser? currentUser;
  Result? result;
  Service? service;
  List<ParameterResult> parameters = [];

  late final GetCurrentUserUseCase _getCurrentUser;
  late final GetUserByUidUseCase _getUserByUid;
  late final GetResultByUserUidUseCase _getResultByUid;
  late final GetServiceByUid _getServiceByUid;

  final FirebaseResultDataSource _resultDataSource = FirebaseResultDataSource();

  @override
  void initState() {
    super.initState();
    _initUseCases();
    _loadData();
  }

  void _initUseCases() {
    final resultRepository = ResultRepositoryImpl(_resultDataSource);

    _getCurrentUser = GetCurrentUserUseCase(
      AuthRepositoryImpl(FirebaseAuthDataSource(FirebaseAuth.instance)),
    );
    _getUserByUid = GetUserByUidUseCase(UserRepositoryImpl(FirebaseUserDataSource()));
    _getResultByUid = GetResultByUserUidUseCase(resultRepository);
    _getServiceByUid = GetServiceByUid(ServiceRepositoryImpl(FirebaseServiceDataSource()));
  }

  Future<void> _loadData() async {
    final authResult = await _getCurrentUser.call();
    final uid = authResult.data?.uid;
    if (uid == null) return;

    final userResult = await _getUserByUid.call(uid);
    final resultData = await _getResultByUid.call(uid);
    if (userResult.data == null || resultData == null) return;

    final serviceResult = await _getServiceByUid.call(resultData.uidService ?? '');
    if (serviceResult.data == null) return;

    final paramValues = await _resultDataSource.getSubcollectionParameters(
      resultData.uid!,
      resultData.uidService ?? '',
    );

    setState(() {
      currentUser = userResult.data;
      result = resultData;
      service = serviceResult.data;
      parameters = paramValues;
      _isLoading = false;
    });
  }

  @override
Widget build(BuildContext context) {
  if (_isLoading || currentUser == null || result == null || service == null) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                    Shadow(color: Colors.white, offset: Offset(-2, 2), blurRadius: 4),
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
                    child: const Icon(Icons.add, color: Colors.white, size: 50),

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
                            Shadow(color: Colors.white, offset: Offset(1, 1), blurRadius: 4),
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
                            Shadow(color: Colors.white, offset: Offset(1, 1), blurRadius: 4),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser!.nombre ?? 'Nombre no disponible',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text("ID: ${currentUser!.uid}"),
                      Text("Fecha del examen: ${result!.createdAt?.toLocal().toString().split(' ')[0] ?? 'Fecha no disponible'}"),
                      const SizedBox(height: 12),
                      Text(
                        service!.name ?? 'Servicio no disponible',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                            decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Parámetro', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Resultados', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Valores', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                           ...parameters.map((param) {
                            final setRange = param.setValue.join(' - ');
                           return TableRow(
                            children: [
                            Padding(
                             padding: const EdgeInsets.all(8.0),
                            child: Text(param.nombre),
                               ),
                                Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('$setRange ${param.unidades ?? ''}'),
                                     ),
                                   Padding(
                                padding: const EdgeInsets.all(8.0),
                                 child: Text(param.valorReferencia ?? ''),
                                ),
                              ],
                            );
                          }).toList(),
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
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
                          onPressed: () {},
                          icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                          label: const Text("Descargar PDF", style: TextStyle(color: Colors.white)),
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
