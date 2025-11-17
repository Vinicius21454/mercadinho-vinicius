import 'package:flutter/material.dart';

class HomePage
 extends StatelessWidget {
  const HomePage
  ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Bem vindo a Home"),
        centerTitle: true,
        backgroundColor: const Color(0xFF08A63B),        ),
      ),
    );
  }
}