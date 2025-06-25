import 'package:flutter/material.dart';
import 'package:lab_cg/domain/citas.dart';

class AgendarCitaScreen extends StatefulWidget {
  const AgendarCitaScreen({super.key});

  @override
  State<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  final _types = [
    'Hemogama Completo',
    'COVID',
    'PCR',
    'Antígeno',
    'Anticuerpos',
  ];
  String? _selectedType;
  DateTime? _selectedDate;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  final _direccionController = TextEditingController();
  final _nombreController = TextEditingController();

  //final AgendarCita _useCase = AgendarCita(LocalCitaDataSource());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Agendar Cita',
              style: TextStyle(
                fontSize: 32, // aumentado
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        _buildStep(' Selección de tipo de prueba'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _selectedType,
                          hint: const Text('Seleccionar'),
                          items:
                              _types
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (value) => setState(() => _selectedType = value),
                          decoration: _inputDecoration(),
                        ),
                        const SizedBox(height: 20),
                        _buildStep(' Selección de fecha y hora'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: _pickDate,
                                child: InputDecorator(
                                  decoration: _inputDecoration(),
                                  child: Text(
                                    _selectedDate == null
                                        ? 'Seleccionar fecha'
                                        : _selectedDate.toString().split(
                                          ' ',
                                        )[0],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButton<TimeOfDay>(
                                value: _selectedTime,
                                underline: const SizedBox(),
                                dropdownColor: Colors.white,
                                style: const TextStyle(color: Colors.black),
                                items:
                                    List.generate(
                                      24,
                                      (i) => TimeOfDay(hour: i, minute: 0),
                                    ).map((t) {
                                      final label =
                                          '${t.hour.toString().padLeft(2, '0')}:00';
                                      return DropdownMenuItem(
                                        value: t,
                                        child: Text(label),
                                      );
                                    }).toList(),
                                onChanged:
                                    (value) =>
                                        setState(() => _selectedTime = value!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildStep(' Dirección de domicilio'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _direccionController,
                          decoration: _inputDecoration(),
                        ),
                        const SizedBox(height: 20),
                        _buildStep(' Nombre del paciente'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nombreController,
                          decoration: _inputDecoration(),
                        ),
                        const SizedBox(height: 24),
                        _buildStep(' Confirmación'),
                        const SizedBox(height: 8),
                        Center(
                          child: SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _submit,
                              child: const Text(
                                'Agendar Cita',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17, // aumentado
        color: Colors.white,
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return const InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (_selectedType == null ||
        _selectedDate == null ||
        _direccionController.text.isEmpty ||
        _nombreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos.')),
      );
      return;
    }

    final cita = CitaLaboratorio(
      uid: 'user_123',
      uidUser: _nombreController.text,
      uidService: _selectedType!,
      requestedAt: _selectedDate!,
      hora: '${_selectedTime.hour.toString().padLeft(2, '0')}:00',
      address: _direccionController.text,
      active: true,
    );

    //await _useCase(cita)_;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cita agendada exitosamente.')),
    );
  }
}