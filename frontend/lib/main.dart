import 'package:flutter/material.dart';
import 'package:petshop_project/screens/login_screen.dart';

/// Ponto de entrada do aplicativo PetShop Control
void main() {
  runApp(const MyApp());
}

/// Widget principal do aplicativo
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Usa 'super.key' para passar o key à classe base

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetShop Control',              // Título do aplicativo
      theme: ThemeData(primarySwatch: Colors.blue), // Tema com cor primária azul
      home: LoginScreen(),             // Tela inicial é a de login
    );
  }
}