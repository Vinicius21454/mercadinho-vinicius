import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avaliacao/login.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  String nomeUsuario = "Carregando...";

  @override
  void initState() {
    super.initState();
    carregarNome();
  }

  Future<void> carregarNome() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final uid = user.uid;

      Map<String, String> nomesFixos = {
        "5zBGoxaqHjVig7QABIfkIeH8dL52": "Gustavo",
        "oS5RfqXjMZVNHN2amWo31uqkNDg2": "Eloisa",
        "cnWMSDLZqcPbapNmWZQ6q6n8MRD3": "Nicolas",
        "Eh5JoyADLKQCt2kQxWn93kCvrRZ2": "Vinicius",
      };

      if (nomesFixos.containsKey(uid)) {
        setState(() => nomeUsuario = nomesFixos[uid]!);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(uid)
          .get();

      if (doc.exists && doc.data()!.containsKey("nome")) {
        setState(() => nomeUsuario = doc.get("nome"));
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCabecalho(),
          buildTituloEFiltragem(),
          Expanded(child: buildListaProdutos()),
        ],
      ),
    );
  }

  Widget buildCabecalho() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3E9C5C), Color(0xFF33C561)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.shopping_cart, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mercadinho do Vinicius',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  nomeUsuario,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTituloEFiltragem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Produtos",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Selecione produtos para adicionar ao carrinho",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildCategoriaBotao("Todos", true),
                buildCategoriaBotao("Grãos", false),
                buildCategoriaBotao("Óleos", false),
                buildCategoriaBotao("Açúcares", false),
                buildCategoriaBotao("Bebidas", false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoriaBotao(String nome, bool selecionado) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {
          // Aqui você pode implementar a lógica de filtragem por categoria
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selecionado ? const Color(0xFF3E9C5C) : Colors.grey[300],
          foregroundColor: selecionado ? Colors.white : Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(nome),
      ),
    );
  }

  Widget buildListaProdutos() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('produtos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Erro ao carregar produtos"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final produtos = snapshot.data!.docs;

        if (produtos.isEmpty) {
          return const Center(child: Text("Nenhum produto disponível"));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: produtos.length,
          itemBuilder: (context, index) {
            final produto = produtos[index];
            final nome = produto['nome'] ?? 'Sem nome';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.shopping_basket, color: Color(0xFF3E9C5C)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$nome adicionado ao carrinho"),
                          backgroundColor: const Color(0xFF3E9C5C),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E9C5C),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Adicionar", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
