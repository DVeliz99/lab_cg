import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lab_cg/domain/service.dart';
import 'appointment_form.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void goToAppController(BuildContext context) {
      Navigator.pushNamed(context, 'app-controller');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
        backgroundColor: Colors.white.withOpacity(0.8),
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'home') goToAppController(context);
            },
            itemBuilder:
                (context) => const [
                  PopupMenuItem<String>(value: 'home', child: Text('Home')),
                ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
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
              return const Center(
                child: Text(
                  'No hay servicios disponibles.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              itemCount: docs.length,
              itemBuilder: (_, i) {
                final data = docs[i].data()! as Map<String, dynamic>;
                final service = Service.fromJson(data, id: docs[i].id);

                return Card(
                  color: Colors.white.withOpacity(0.9),
                  child: ListTile(
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
                          builder:
                              (_) => AppointmentFormScreen(service: service),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
