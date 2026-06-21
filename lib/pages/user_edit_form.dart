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
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    nameController.text = user.name;
    surnameController.text = user.surname;
    emailController.text = user.email;
    if (user.birthDate.isNotEmpty) {
      try {
        final date = DateTime.parse(user.birthDate);
        _selectedDate = date;
        _birthDateController.text =
            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modificar datos usuario')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
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
              const SizedBox(height: 20),
              TextFormField(
                controller: surnameController,
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
                onSaved: (value) => surnameController.text = value ?? '',
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'email@email.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
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
                onSaved: (value) => emailController.text = value ?? '',
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _birthDateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Fecha de nacimiento',
                  hintText: 'dd/MM/yyyy',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (_) => _selectedDate == null
                    ? 'por favor seleccione la fecha de nacimiento'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Nueva contraseña',
                  hintText: 'Mínimo 6 caracteres',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'por favor digite la contraseña';
                  }
                  if (value.length < 6) return 'mínimo 6 caracteres';
                  return null;
                },
                onSaved: (value) => passwordController.text = value ?? '',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final user = User(
                        id: widget.user.id,
                        name: nameController.text,
                        surname: surnameController.text,
                        email: emailController.text,
                        birthDate: _selectedDate!.toIso8601String(),
                        password: passwordController.text,
                      );
                      Navigator.pop(context, user);
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
