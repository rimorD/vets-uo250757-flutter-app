import 'package:flutter/material.dart';
import 'package:vets_uo250757_flutter_app/pages/custom_dialog_alert.dart';
import 'package:vets_uo250757_flutter_app/pages/login_page.dart';
import 'package:vets_uo250757_flutter_app/pages/user_detail_page.dart';
import 'package:vets_uo250757_flutter_app/pages/user_edit_form.dart';
import 'package:vets_uo250757_flutter_app/pages/user_signup_form.dart';
import 'package:vets_uo250757_flutter_app/services/api_service.dart';
import 'package:vets_uo250757_flutter_app/src/user.dart';

class HomePage extends StatefulWidget {
  //final String _title;
  const HomePage({super.key}); // recibimos el titulo en el constructor
  @override
  State<StatefulWidget> createState() => StateHomePage();
}

class StateHomePage extends State<HomePage> {
  List<User> users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _navigateToLogin() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    try {
      final result = await ApiService.getUsers();
      if (mounted)
        setState(() {
          users = result;
          _loading = false;
        });
    } on UnauthorizedException {
      _navigateToLogin();
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al cargar usuarios: ${e.toString().replaceFirst('Exception: ', '')}',
            ),
          ),
        );
      }
    }
  }

  void _deleteUser(User user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Borrar usuario"),
        content: Text("Está seguro de borrar el usuario:${user.name}."),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Capture before async gap.
              final messenger = ScaffoldMessenger.of(context);
              try {
                await ApiService.deleteUser(user.id!);
                if (mounted) {
                  setState(() => users.remove(user));
                  showDialog(
                    context: context,
                    builder: (_) => CustomAlertDialog.create(
                      context,
                      'Información',
                      'El usuario ${user.name} ha sido eliminado.',
                    ),
                  );
                }
              } on UnauthorizedException {
                _navigateToLogin();
              } catch (e) {
                if (mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error al eliminar: ${e.toString().replaceFirst('Exception: ', '')}',
                      ),
                    ),
                  );
                }
              }
            },
            child: const Text("Borrar", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "cancelar",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Listado de clientes")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? const Center(child: Text('No hay usuarios registrados.'))
          : ListView.builder(
              itemCount: users.length,
              // Use _ to avoid shadowing the State's context.
              itemBuilder: (_, index) {
                final user = users[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserDetailPage(user: user),
                      ),
                    );
                  },
                  onLongPress: () => _deleteUser(user),
                  title: Text('${user.name} ${user.surname}'),
                  subtitle: Text(user.email),
                  leading: CircleAvatar(
                    child: Text(user.name.substring(0, 1).toUpperCase()),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    tooltip: 'Editar',
                    onPressed: () async {
                      final modifiedUser = await Navigator.push<User>(
                        this.context,
                        MaterialPageRoute(
                          builder: (_) => UserEditForm(user: user),
                        ),
                      );
                      if (modifiedUser == null || !mounted) return;
                      final messenger = ScaffoldMessenger.of(this.context);
                      try {
                        await ApiService.updateUser(modifiedUser);
                        if (!mounted) return;
                        setState(() {
                          users.removeAt(index);
                          users.insert(index, modifiedUser);
                        });
                        showDialog(
                          context: this.context,
                          builder: (_) => CustomAlertDialog.create(
                            this.context,
                            'Información',
                            'El usuario ${modifiedUser.name} ha sido actualizado correctamente.',
                          ),
                        );
                      } on UnauthorizedException {
                        _navigateToLogin();
                      } catch (e) {
                        if (mounted) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error al actualizar: ${e.toString().replaceFirst('Exception: ', '')}',
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Registrar usuario',
        onPressed: () async {
          final newUser = await Navigator.push<User>(
            this.context,
            MaterialPageRoute(builder: (_) => const UserSignUpForm()),
          );
          if (newUser == null || !mounted) return;
          final messenger = ScaffoldMessenger.of(this.context);
          try {
            await ApiService.createUser(newUser);
            if (!mounted) return;
            await _loadUsers();
            if (!mounted) return;
            showDialog(
              context: this.context,
              builder: (_) => CustomAlertDialog.create(
                this.context,
                'Información',
                'El usuario ${newUser.name} ha sido registrado.',
              ),
            );
          } on UnauthorizedException {
            _navigateToLogin();
          } catch (e) {
            if (mounted) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    'Error al registrar: ${e.toString().replaceFirst('Exception: ', '')}',
                  ),
                ),
              );
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
