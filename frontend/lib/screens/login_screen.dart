import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Tela de login com opções de login, registro e reset de senha
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // Usa 'super.key' para passar o key à classe base

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para os campos de texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Realiza o login enviando uma requisição ao backend
  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );
    final data = jsonDecode(response.body);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] as String)),
      );
      if (data['success'] as bool) {
        // TODO: Adicionar navegação para a próxima tela após login
      }
    }
  }

  /// Registra um novo usuário enviando uma requisição ao backend
  Future<void> _register() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );
    final data = jsonDecode(response.body);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] as String)),
      );
    }
  }

  /// Solicita o reset de senha enviando uma requisição ao backend
  Future<void> _resetPassword() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/reset'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text,
      }),
    );
    final data = jsonDecode(response.body);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] as String)),
      );
    }
  }

  Future<void> _testConnection() async {
    print('📩 Testando conexão com o servidor...');

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:2620/login'), // Altere para o IP correto se necessário
      );

      print('📩 Status code: ${response.statusCode}');
      print('📩 Resposta: ${response.body}');
    } catch (e) {
      print('❌ Erro ao conectar ao backend: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetShop Control - Login'), // Título da tela
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            // Campo de senha
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Oculta a senha
            ),
            const SizedBox(height: 24),
            // Botão de login
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 8),
            // Botão de registro
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Registrar'),
            ),
            const SizedBox(height: 8),
            // Botão de reset de senha
            TextButton(
              onPressed: _resetPassword,
              child: const Text('Esqueci minha senha'),
            ),
            ElevatedButton(
              onPressed: _testConnection,
              child: const Text('Testar Conexão'),
            ),

          ],
        ),
      ),
    );
  }
}
