import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:lab_cg/domain/service.dart';
import 'appointment_form.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('services')
                .where('active', isEqualTo: true)
                .orderBy('name')
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
            return const Center(child: Text('No hay servicios disponibles.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (_, i) {
              final data = docs[i].data()! as Map<String, dynamic>;
              final service = Service.fromJson(data, id: docs[i].id);

              return ListTile(
                leading: const Icon(Icons.medical_services_outlined),
                title: Text(service.name),
                subtitle:
                    service.price != null
                        ? Text('L ${service.price!.toStringAsFixed(2)}')
                        : null,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AppointmentFormScreen(service: service),
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
