import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  const Dropdown({super.key});

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? selectedValue;

  // Para simular toggles individuales por opción
  Map<String, bool> toggles = {'celular': false, 'correo': false};

  void toggleOption(String key) {
    setState(() {
      toggles[key] = !(toggles[key] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.notification_add, size: 40),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Método de\nContacto',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        DropdownButton<String>(
          value: selectedValue,
          hint: Icon(Icons.arrow_downward, size: 40),
          underline: SizedBox.shrink(),
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
          items: [
            DropdownMenuItem(
              value: 'celular',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.phone, size: 30, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text('Celular', style: TextStyle(fontSize: 20)),
                  ),
                  GestureDetector(
                    onTap: () {
                      toggleOption('celular');
                    },
                    child: Icon(
                      toggles['celular']! ? Icons.toggle_on : Icons.toggle_off,
                      color: toggles['celular']! ? Colors.green : Colors.grey,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'correo',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.email, size: 30, color: Colors.red),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Correo\nElectrónico',
                      style: TextStyle(fontSize: 20),
                      maxLines: 2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      toggleOption('correo');
                    },
                    child: Icon(
                      toggles['correo']! ? Icons.toggle_on : Icons.toggle_off,
                      color: toggles['correo']! ? Colors.green : Colors.grey,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
