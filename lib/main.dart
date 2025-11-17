import 'package:flutter/material.dart';
import 'login.dart'; // 👈 importa sua tela de login
// se quiser já importar a home também:
// import 'home.dart';

void main() {
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // tira a faixa "debug"
      title: 'Mercadinho do Vinícius',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(), // 👈 primeira tela será o login
    );
  }
}
