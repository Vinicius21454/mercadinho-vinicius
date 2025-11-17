import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final senha = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    senha.dispose();
    super.dispose();
  }

  // 🔐 LOGIN COM FIREBASE
  Future<void> loginFirebase() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: senha.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = "Erro ao fazer login";
      if (e.code == 'user-not-found') {
        msg = "Usuário não encontrado";
      } else if (e.code == 'wrong-password') {
        msg = "Senha incorreta";
      } else if (e.code == 'invalid-email') {
        msg = "E-mail inválido";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro inesperado")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F9EF),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(Icons.shopping_cart, size: 60),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                campo("E-mail", email, Icons.email),
                const SizedBox(height: 25),
                campo("Senha", senha, Icons.lock, senha: true),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                    ),
                    onPressed: loginFirebase,
                    child: const Text(
                      "Entrar",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget campo(String label, TextEditingController ctrl, IconData icon,
      {bool senha = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: ctrl,
            obscureText: senha,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              border: InputBorder.none,
              hintText: label,
              hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        )
      ],
    );
  }
}
