import 'package:flutter/material.dart';
import 'package:vets_uo250757_flutter_app/src/user.dart';

class UserEditForm extends StatefulWidget {
  final User user;
  const UserEditForm({super.key, required this.user});
  @override
  State<StatefulWidget> createState() => StateUserEditForm();
}

class StateUserEditForm extends State<UserEditForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    User user = widget.user;
    nameController.text = user.name;
    surnameController.text = user.surname;
    emailController.text = user.email;
    phoneController.text = user.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modificar datos usuario")),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Introduce tu nombre',
                border: OutlineInputBorder(),
              ),
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
              onSaved: (value) => nameController.text = value ?? '',
            ),
            TextFormField(
              controller: surnameController,
              decoration: const InputDecoration(
                labelText: 'Apellidos',
                hintText: 'Introduce tu apellidos',
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
                surnameController.text = value ?? '';
              },
            ),
            TextFormField(
              controller: emailController,
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
                emailController.text = value ?? '';
              },
            ),
            TextFormField(
              controller: phoneController,
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
                phoneController.text = value ?? '';
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    _formKey.currentState!.save();
                    User user = User(
                      nameController.text,
                      surnameController.text,
                      emailController.text,
                      phoneController.text,
                    );
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
