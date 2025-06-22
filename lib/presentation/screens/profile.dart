/*
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nombreController = TextEditingController();
  final _edadController = TextEditingController();
  final _alturaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();
  final _direccionController = TextEditingController();

  String _sexo = 'Masculino';
  String _tipoSangre = 'A+';

  final _saveUserProfile = SaveUserProfile(LocalUserDataSource());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Stack(
        children: [
          // Fondo con imagen
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Capa oscura semitransparente
          Container(color: Colors.black.withAlpha(153)),

          // Contenido encima
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTextField('Nombre', _nombreController),
                Row(
                  children: [
                    Expanded(child: _buildDropdownSexo()),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTextField(
                        'Edad',
                        _edadController,
                        isNumber: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        'Altura',
                        _alturaController,
                        isDecimal: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTextField(
                        'Peso',
                        _pesoController,
                        isDecimal: true,
                      ),
                    ),
                  ],
                ),
                _buildDropdownSangre(),
                _buildTextField(
                  'Teléfono',
                  _telefonoController,
                  isNumber: true,
                ),
                _buildTextField('Correo', _correoController),
                _buildTextField('Dirección', _direccionController),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text(''),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _guardarPerfil,
                      child: const Text('Guardar Perfil'),
                    ),
                  ],
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
    bool isNumber = false,
    bool isDecimal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType:
            isDecimal
                ? const TextInputType.numberWithOptions(decimal: true)
                : (isNumber ? TextInputType.number : TextInputType.text),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white, // fondo blanco del campo
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          border: const OutlineInputBorder(),
        ),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildDropdownSexo() {
    return DropdownButtonFormField<String>(
      value: _sexo,
      items:
          [
            'Masculino',
            'Femenino',
            'Otro',
          ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
      onChanged: (val) => setState(() => _sexo = val!),
      style: const TextStyle(color: Colors.black),
      dropdownColor: Colors.white,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Sexo', // o 'Tipo de sangre'
        labelStyle: TextStyle(
          color: Colors.black,
        ), // <-- aquí forzamos texto visible
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildDropdownSangre() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _tipoSangre,
        items:
            [
              'A+',
              'A-',
              'B+',
              'B-',
              'AB+',
              'AB-',
              'O+',
              'O-',
            ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
        onChanged: (val) => setState(() => _tipoSangre = val!),
        style: const TextStyle(color: Colors.black),
        dropdownColor: Colors.white,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Tipo de Sangre', // o 'Tipo de sangre'
          labelStyle: TextStyle(
            color: Colors.black,
          ), // <-- aquí forzamos texto visible
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  void _guardarPerfil() {
    final perfil = UserProfile(
      nombre: _nombreController.text,
      sexo: _sexo,
      edad: int.tryParse(_edadController.text) ?? 0,
      altura: double.tryParse(_alturaController.text) ?? 0.0,
      peso: double.tryParse(_pesoController.text) ?? 0.0,
      tipoSangre: _tipoSangre,
      telefono: _telefonoController.text,
      correo: _correoController.text,
      direccion: _direccionController.text,
    );

    _saveUserProfile(perfil);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Perfil guardado')));
  }
}
*/
