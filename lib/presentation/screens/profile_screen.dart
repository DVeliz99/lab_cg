import 'package:flutter/material.dart';
import 'package:lab_cg/domain/profile.dart';
import 'package:lab_cg/use_cases/profile_use_cases.dart';
import 'package:lab_cg/data/data_sources/data_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _gender = ValueNotifier<String>('Masculino');
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bloodType = ValueNotifier<String>('A+');
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  final SaveProfile saveProfile = SaveProfile(DataProfile());

  void _save() {
    if (_formKey.currentState!.validate()) {
      final profile = Profile(
        name: _nameController.text,
        gender: _gender.value,
        age: int.parse(_ageController.text),
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        bloodType: _bloodType.value,
        phone: _phoneController.text,
        email: _emailController.text,
        address: _addressController.text,
      );

      saveProfile(profile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Perfil guardado exitosamente")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                children: [
                  _buildAppBar(),
                  _buildTextField("Nombre", _nameController),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown("Sexo", _gender, [
                          "Masculino",
                          "Femenino",
                        ]),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          "Edad",
                          _ageController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          "Altura",
                          _heightController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          "Peso",
                          _weightController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  _buildDropdown("Tipo de sangre", _bloodType, [
                    "A+",
                    "A-",
                    "B+",
                    "B-",
                    "AB+",
                    "AB-",
                    "O+",
                    "O-",
                  ]),
                  _buildTextField(
                    "Teléfono",
                    _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextField(
                    "Correo",
                    _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildTextField("Dirección", _addressController),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: const [
          BackButton(color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Perfil',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 4,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? 'Campo requerido' : null,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    ValueNotifier<String> value,
    List<String> options,
  ) {
    return ValueListenableBuilder(
      valueListenable: value,
      builder:
          (_, current, __) => DropdownButtonFormField<String>(
            value: current,
            items:
                options
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (val) => value.value = val!,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.white,
            ),
          ),
    );
  }
}
