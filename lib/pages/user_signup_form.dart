import 'package:flutter/material.dart';
import 'package:vets_uo250757_flutter_app/src/user.dart';

// Create a Form widget.
class UserSignUpForm extends StatefulWidget {
  const UserSignUpForm({super.key});
  @override
  UserSignUpFormState createState() => UserSignUpFormState();
}

class UserSignUpFormState extends State<UserSignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _surname = "";
  String _email = "";
  String _phone = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de usuarios")),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // Espaciado de 20 píxeles
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Introduce tu nombre',
                border: OutlineInputBorder(),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'por favor digite el nombre';
                }
                if (value.length < 2) return 'mínimo 2 caracteres';
                if (value.length > 50) return 'máximo 50 caracteres';
                final regex = RegExp(r'^[a-zA-ZáéíóúüñÁÉÍÓÚÜÑ\s]+$');
                if (!regex.hasMatch(value)) {
                  return 'solo se permiten letras y espacios';
                }
                return null;
              },
              onSaved: (value) => _name = value ?? '',
            ),
            const SizedBox(height: 20), // Espaciado de 20 píxeles

            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Apellidos',
                hintText: 'Introduce tus apellidos',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'por favor digite los apellidos';
                }
                if (value.length < 2) return 'mínimo 2 caracteres';
                if (value.length > 50) return 'máximo 50 caracteres';
                final regex = RegExp(r'^[a-zA-ZáéíóúüñÁÉÍÓÚÜÑ\s]+$');
                if (!regex.hasMatch(value)) {
                  return 'solo se permiten letras y espacios';
                }
                return null;
              },
              onSaved: (value) {
                _surname = value ?? '';
              },
            ),
            const SizedBox(height: 20), // Espaciado de 20 píxeles

            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Introduce tu email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'por favor digite el email';
                }
                final regex = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w{2,}$');
                if (!regex.hasMatch(value)) {
                  return 'formato inválido (ej: email@email.com)';
                }
                return null;
              },
              onSaved: (value) {
                _email = value ?? '';
              },
            ),
            const SizedBox(height: 20), // Espaciado de 20 píxeles

            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                hintText: '999-999-999-999',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'por favor digite el teléfono';
                }
                final regex = RegExp(r'^\d{3}-\d{3}-\d{3}-\d{3}$');
                if (!regex.hasMatch(value)) {
                  return 'formato inválido (ej: 034-999-999-977)';
                }
                return null;
              },
              onSaved: (value) {
                _phone = value ?? '';
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    User user = User(_name, _surname, _email, _phone);
                    Navigator.pop(context, user);
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
