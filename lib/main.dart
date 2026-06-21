import 'package:flutter/material.dart';
import 'package:vets_uo250757_flutter_app/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Aplicación para la gestión de veterinarias (uo250757)",
      home: HomePage(),
    );
  }
}
