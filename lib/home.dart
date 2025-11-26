import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:avaliacao/login.dart';
import 'package:avaliacao/produtos_page.dart';

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

        if (doc.exists && doc.data() != null && doc.data()!.containsKey("nome")) {
          setState(() => nomeUsuario = doc.get("nome"));
        } else {
          setState(() => nomeUsuario = "Usuário");
        }
      } catch (e) {
        setState(() => nomeUsuario = "Usuário");
      }
    }

  // ===========================================================
  // build
  // ===========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            buildCabecalho(),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildHeaderResumo(nomeUsuario),
            ),

            const SizedBox(height: 20),

            // =====================
            // GRID ESTILIZADO
            // =====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProdutosPage()),
                      );
                    },
                    child: buildCardEstilizado(
                      "Produtos",
                      Icons.inventory_2,
                      Colors.blue,
                      "8",
                      "+5",
                    ),
                  ),
                  buildCardEstilizado(
                    "Vendas Hoje",
                    Icons.attach_money,
                    Colors.green,
                    "R\$ 1.250",
                    "+18%",
                  ),
                  buildCardEstilizado(
                    "Pedidos",
                    Icons.shopping_bag,
                    Colors.orange,
                    "23",
                    "+12%",
                  ),
                  buildCardEstilizado(
                    "Crescimento",
                    Icons.show_chart,
                    Colors.purple,
                    "+12%",
                    "+3%",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildAtividadeRecente(),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // CABEÇALHO
  // ===========================================================
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
              child:
                  const Icon(Icons.shopping_cart, color: Colors.white, size: 30),
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
                  'Olá, $nomeUsuario',
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

  // ===========================================================
  // CARD ESTILIZADO (NOVO)
  // ===========================================================
  Widget buildCardEstilizado(
      String titulo, IconData icon, Color cor, String valor, String crescimento) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent, // sem fundo
        border: Border.all(
          color: cor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 38, color: cor),
          const SizedBox(height: 10),
          Text(
            titulo,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            valor,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            crescimento,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================================================
// RESUMO
// ===============================================================
Widget buildHeaderResumo(String nome) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF3E9C5C), Color(0xFF33C561)],
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
          child: const Icon(Icons.auto_graph, color: Colors.white, size: 26),
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

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border:
                Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child:
              const Icon(Icons.notifications_none, color: Colors.white, size: 26),
        ),
      ],
    ),
  );
}

// ===============================================================
// ATIVIDADES RECENTES
// ===============================================================
Widget buildAtividadeRecente() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.black.withOpacity(0.1),
        width: 1.3,
      ),
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(40, 0, 0, 0),
          blurRadius: 10,
          offset: Offset(2, 8),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Atividade Recente",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          "Últimas movimentações",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 20),

        buildItemAtividade(
          icon: Icons.attach_money,
          iconColor: Colors.green,
          label: "Venda de Arroz Branco 5kg",
          tempo: "5 min atrás",
          valor: "R\$ 25,90",
        ),
        Divider(color: Colors.grey[300]),

        buildItemAtividade(
          icon: Icons.inventory_2,
          iconColor: Colors.blue,
          label: "Estoque de Café atualizado",
          tempo: "15 min atrás",
        ),
        Divider(color: Colors.grey[300]),

        buildItemAtividade(
          icon: Icons.attach_money,
          iconColor: Colors.green,
          label: "Venda de Leite Integral 1L",
          tempo: "30 min atrás",
          valor: "R\$ 5,80",
        ),
        Divider(color: Colors.grey[300]),

        buildItemAtividade(
          icon: Icons.attach_money,
          iconColor: Colors.green,
          label: "Venda de Óleo de Soja",
          tempo: "1 hora atrás",
          valor: "R\$ 7,20",
        ),
      ],
    ),
  );
}

// ===============================================================
// ITEM ATIVIDADE
// ===============================================================
Widget buildItemAtividade({
  required IconData icon,
  required Color iconColor,
  required String label,
  required String tempo,
  String? valor,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.shade300,
          width: 1.2,
        ),
      ),
    ),
    child: Row(
      children: [
        // Ícone com borda
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(
              color: iconColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),

        const SizedBox(width: 14),

        // Texto principal
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                tempo,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        // Valor à direita (com borda)
        if (valor != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.green,
                width: 1.8,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              valor,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.green,
              ),
            ),
          ),
      ],
    ),
  );
}
