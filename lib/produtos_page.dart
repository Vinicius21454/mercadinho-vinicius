import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avaliacao/login.dart';
import 'carrinho.dart';


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

  // Ícone com fundo verde
  Widget getIconeProduto(String nome) {
    nome = nome.toLowerCase();
    Icon icone;

    if (nome.contains("arroz")) {
      icone = const Icon(Icons.rice_bowl, color: Color(0xFF3E9C5C), size: 24);
    } else if (nome.contains("feijão") || nome.contains("feijao")) {
      icone = const Icon(Icons.eco, size: 24, color: Color(0xFF3E9C5C));
    } else if (nome.contains("carne")) {
      icone = const Icon(Icons.set_meal, size: 24, color: Color(0xFF3E9C5C));
    } else if (nome.contains("leite")) {
      icone = const Icon(Icons.local_drink, size: 24, color: Color(0xFF3E9C5C));
    } else {
      icone = const Icon(Icons.shopping_basket, size: 24, color: Color(0xFF3E9C5C));
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFFBFF5D2),
        shape: BoxShape.circle,
      ),
      child: icone,
    );
  }

  // -----------------------------------------------------------
  // 🔥 ADICIONAR AO CARRINHO
  // -----------------------------------------------------------
  Future<void> adicionarAoCarrinho(String id, String nome, double preco) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final ref = FirebaseFirestore.instance
        .collection("carrinho")
        .doc(uid)
        .collection("itens")
        .doc(id);

    final doc = await ref.get();

    if (doc.exists) {
      await ref.update({
        "quantidade": doc["quantidade"] + 1,
      });
    } else {
      await ref.set({
        "nome": nome,
        "preco": preco,
        "quantidade": 1,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),
          buildTituloEFiltragem(),
          Expanded(child: buildListaProdutos()),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  // HEADER
  // -----------------------------------------------------------
  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3E9C5C), Color(0xFF33C561)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shopping_cart, color: Colors.white, size: 28),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mercadinho do Vinicius",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  nomeUsuario,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const Spacer(),

            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white, size: 28),
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
        children: const [
          Text(
            "Produtos",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 4),

          Text(
            "Selecione produtos para adicionar ao carrinho",
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  // LISTA DE PRODUTOS + PREÇO
  // -----------------------------------------------------------
  Widget buildListaProdutos() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('produtos').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final produtos = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: produtos.length,
          itemBuilder: (context, index) {
            final produto = produtos[index];
            final nome = produto["nome"] ?? "Sem nome";
            final preco = (produto["preco"] ?? 0).toDouble();

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
                  getIconeProduto(nome),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "R\$ ${preco.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      adicionarAoCarrinho(produto.id, nome, preco);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$nome adicionado ao carrinho"),
                          backgroundColor: const Color(0xFF3E9C5C),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E9C5C),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "Adicionar",
                      style: TextStyle(color: Colors.white),
                    ),
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
