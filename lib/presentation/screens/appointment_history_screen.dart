import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AppointmentHistoryScreen extends StatelessWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Debes iniciar sesión')));
    }

    final citasStream =
        FirebaseFirestore.instance
            .collection('appoinments')
            .where('uid_user', isEqualTo: user.uid)
            .orderBy('start_at', descending: true)
            .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de citas')),
      body: StreamBuilder<QuerySnapshot>(
        stream: citasStream,
        builder: (_, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final citas = snap.data!.docs;
          if (citas.isEmpty) {
            return const Center(child: Text('Sin citas registradas'));
          }

          return ListView.separated(
            itemCount: citas.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, i) {
              final cita = citas[i];
              final uidService = cita['uid_service'] as String;
              final startAt =
                  (cita['start_at'] as Timestamp).toDate(); // DateTime
              final serviceName =
                  cita['service_name'] ?? 'Servicio: $uidService';

              return ListTile(
                leading: const Icon(Icons.schedule),
                title: Text(serviceName),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd ‧ HH:mm').format(startAt),
                ),
                trailing: const Icon(
                  Icons.hourglass_bottom,
                  color: Colors.orangeAccent,
                ),
                onTap: () async {
                  final resultId = await _findResultId(
                    uidUser: user.uid,
                    uidService: uidService,
                  );

                  Navigator.pushNamed(
                    context,
                    'resultados',
                    arguments: {'resultId': resultId}, // null = pendiente
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<String?> _findResultId({
    required String uidUser,
    required String uidService,
  }) async {
    final snap =
        await FirebaseFirestore.instance
            .collection('results')
            .where('uid_user', isEqualTo: uidUser)
            .where('uid_service', isEqualTo: uidService)
            .orderBy('created_at', descending: true)
            .limit(1)
            .get();

    if (snap.docs.isEmpty) return null;
    return snap.docs.first.id;
  }
}
