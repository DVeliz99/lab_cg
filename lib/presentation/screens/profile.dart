import 'package:flutter/material.dart';
import 'package:lab_cg/domain/profile.dart';
import 'package:lab_cg/data/implements/profile_repository_impl.dart';
import 'package:lab_cg/data/firebase_data_sources/firebase_profile_data_source.dart';
import 'package:lab_cg/use_cases/profile_use_cases.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _gender = ValueNotifier<String>('masculino');
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bloodType = ValueNotifier<String>('A+');
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  late final SaveProfile saveProfile;
  late final GetProfileUseCase getProfile;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final repository = ProfileRepositoryImpl(FirebaseProfileDataSource());
    saveProfile = SaveProfile(repository);
    getProfile = GetProfileUseCase(repository);
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    print("🔄 Starting to load profile...");
    final result = await getProfile();
    print("📦 Result from getProfile(): $result");

    if (!mounted) return;

    if (result.isSuccess && result.data != null) {
      final profile = result.data as Profile;

      _nameController.text = profile.name;
      _gender.value = profile.gender;
      _ageController.text = profile.age.toString();
      _heightController.text = profile.height.toString();
      _weightController.text = profile.weight.toString();
      _bloodType.value = profile.bloodType;
      _phoneController.text = profile.phone;
      _emailController.text = profile.email;
      _addressController.text = profile.address;
    } else if (result.isFailure && result.failure != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error cargando perfil: ${result.failure!.message}"),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _save() async {
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

      await saveProfile(profile);

      // 🔁 También actualizar el nombre en la colección 'users'
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'nombre': _nameController.text,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Perfil guardado exitosamente")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.8),
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0F2027),
                      Color(0xFF203A43),
                      Color(0xFF2C5364),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ListView(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Editar Usuario',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 26,
                                  shadows: [
                                    const Shadow(
                                      color: Colors.white,
                                      offset: Offset(-2, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
                                  "Altura (Metros)",
                                  _heightController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(
                                  "Peso (Libras)",
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
    return ValueListenableBuilder<String>(
      valueListenable: value,
      builder:
          (_, current, __) => DropdownButtonFormField<String>(
            value: options.contains(current) ? current : null,
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
