import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab_cg/domain/citas.dart';
import 'package:lab_cg/domain/service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Debes iniciar sesión para ver tu historial')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de citas')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appoinments')
            .where('uid_user', isEqualTo: currentUser.uid)
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No tienes citas registradas.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final data = docs[i].data()! as Map<String, dynamic>;
              final cita = CitaLaboratorio.fromMap(data, docs[i].id);

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('services')
                    .doc(cita.uidService)
                    .get(),
                builder: (context, serviceSnap) {
                  String serviceName = '';
                  if (serviceSnap.hasData && serviceSnap.data!.exists) {
                    serviceName = Service.fromJson(
                      serviceSnap.data!.data()! as Map<String, dynamic>,
                      id: serviceSnap.data!.id,
                    ).name;
                  }

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        cita.active
                            ? Icons.schedule
                            : Icons.check_circle_outline,
                      ),
                      title: Text(serviceName.isEmpty
                          ? 'Servicio: ${cita.uidService}'
                          : serviceName),
                      subtitle: Text(
                          '${cita.requestedAt.toLocal().toString().substring(0, 16)}  •  ${cita.hora}'),
                      trailing: Icon(
                        cita.active ? Icons.hourglass_top_outlined : Icons.check,
                        color: cita.active ? Colors.orange : Colors.green,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}