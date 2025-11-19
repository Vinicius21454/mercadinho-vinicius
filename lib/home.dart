import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avaliacao/login.dart';

class HomePage extends StatefulWidget {
  final String? nomeUsuario;

  const HomePage({super.key, this.nomeUsuario});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String nomeUsuario = "Carregando...";

  @override
  void initState() {
    super.initState();
    if (widget.nomeUsuario != null && widget.nomeUsuario!.trim().isNotEmpty) {
      nomeUsuario = widget.nomeUsuario!;
    } else {
      carregarNome();
    }
  }

  Future<void> carregarNome() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => nomeUsuario = "Usuário");
        return;
      }

      final uid = user.uid;

      if (uid == "5zBGoxaqHjVig7QABIfkIeH8dL52") {
        setState(() => nomeUsuario = "Gustavo");
      } else if (uid == "oS5RfqXjMZVNHN2amWo31uqkNDg2") {
        setState(() => nomeUsuario = "Eloisa");
      } else if (uid == "cnWMSDLZqcPbapNmWZQ6q6n8MRD3") {
        setState(() => nomeUsuario = "Nicolas");
      } else if (uid == "Eh5JoyADLKQCt2kQxWn93kCvrRZ2") {
        setState(() => nomeUsuario = "Vinicius");
      } else {
        final doc = await FirebaseFirestore.instance
            .collection("usuarios")
            .doc(uid)
            .get();
        if (doc.exists) {
          final dados = doc.data();
          if (dados != null && dados.containsKey("nome")) {
            setState(() => nomeUsuario = dados["nome"]);
          } else {
            setState(() => nomeUsuario = "Usuário");
          }
        } else {
          setState(() => nomeUsuario = "Usuário");
        }
      }
    } catch (e) {
      setState(() => nomeUsuario = "Usuário");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // CABEÇALHO
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 62, 156, 92),
                  Color.fromARGB(255, 51, 197, 97),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mercadinho do Vinicius',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Olá, $nomeUsuario',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white24,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Sair",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // RESUMO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: buildHeaderResumo(nomeUsuario),
          ),
          const SizedBox(height: 20),
          // CARDS 2x2 MENOR
          Expanded(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.55, // cards bem compactos
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    buildCardDashboard("Produtos Ativos", Icons.inventory_2,
                        Colors.blue, "8", "+5", () {}),
                    buildCardDashboard("Vendas Hoje", Icons.attach_money,
                        Colors.green, "R\$ 1.250,00", "+18%", () {}),
                    buildCardDashboard("Pedidos", Icons.shopping_bag,
                        Colors.orange, "23", "+12", () {}),
                    buildCardDashboard("Crescimento", Icons.show_chart,
                        Colors.purple, "+12%", "+3%", () {}),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// WIDGET PARA O RESUMO
Widget buildHeaderResumo(String nome) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 62, 156, 92),
          Color.fromARGB(255, 51, 197, 97),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(40),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border:
                Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.auto_graph,
            color: Colors.white,
            size: 26,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Olá, $nome! 👋",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Aqui está seu resumo de hoje",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border:
                Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.notifications_none,
            color: Colors.white,
            size: 26,
          ),
        ),
      ],
    ),
  );
}

// WIDGET PARA OS CARDS BEM MENORES E CENTRALIZADOS
Widget buildCardDashboard(
  String titulo,
  IconData icon,
  Color corIcone,
  String valor,
  String crescimento,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8), // padding menor
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // centraliza vertical
        crossAxisAlignment: CrossAxisAlignment.center, // centraliza horizontal
        children: [
          Icon(icon, color: corIcone, size: 22),
          const SizedBox(height: 4),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            valor,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_upward, color: Colors.green, size: 14),
              const SizedBox(width: 2),
              Text(
                crescimento,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
