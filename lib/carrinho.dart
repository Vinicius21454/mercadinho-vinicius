import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
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

  Stream<QuerySnapshot> getCarrinhoStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection("carrinho")
        .doc(uid)
        .collection("itens")
        .snapshots();
  }

  Future<void> atualizarQuantidade(String id, int quantidade) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (quantidade <= 0) {
      await removerItem(id);
      return;
    }

    await FirebaseFirestore.instance
        .collection("carrinho")
        .doc(uid)
        .collection("itens")
        .doc(id)
        .update({"quantidade": quantidade});
  }

  Future<void> removerItem(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("carrinho")
        .doc(uid)
        .collection("itens")
        .doc(id)
        .delete();
  }

  double calcularTotal(QuerySnapshot snapshot) {
    double total = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      final preco = (data.containsKey("preco"))
          ? (data["preco"] as num).toDouble()
          : 0.0;

      final quantidade = (data.containsKey("quantidade"))
          ? data["quantidade"]
          : 1;

      total += preco * quantidade;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF43A047),
                Color(0xFF66BB6A),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Carrinho",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          nomeUsuario,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed("/login");
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      backgroundColor: Colors.grey[100],

      body: StreamBuilder<QuerySnapshot>(
        stream: getCarrinhoStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final itens = snapshot.data!.docs;

          if (itens.isEmpty) {
            return const Center(
              child: Text(
                "Carrinho vazio 😢",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          double total = calcularTotal(snapshot.data!);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: itens.length,
                  itemBuilder: (context, index) {
                    final item = itens[index];
                    final data = item.data() as Map<String, dynamic>;

                    final nome = data["nome"] ?? "Sem nome";
                    final preco = (data["preco"] ?? 0).toDouble();
                    final qtd = data["quantidade"] ?? 1;

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
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: const Icon(Icons.shopping_bag,
                                color: Colors.green, size: 28),
                          ),
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
                                Text(
                                  "R\$ ${preco.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle,
                                    color: Colors.red),
                                onPressed: () =>
                                    atualizarQuantidade(item.id, qtd - 1),
                              ),
                              Text(
                                qtd.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle,
                                    color: Colors.green),
                                onPressed: () =>
                                    atualizarQuantidade(item.id, qtd + 1),
                              ),
                            ],
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removerItem(item.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 6),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "TOTAL",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "R\$ ${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF43A047),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
