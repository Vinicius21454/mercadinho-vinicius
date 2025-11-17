import 'package:flutter/material.dart';
import 'package:avaliacao/login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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

                    // TEXTOS
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Mercadinho do Vinicius',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Olá, Gustavo',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // BOTÃO SAIR
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white24,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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

            // CARD VERDE IGUAL AO DA IMAGEM
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildHeaderResumo(),
            ),

          ],
        ),
      ),
    );
  }
}

//Card verde do usuario

Widget buildHeaderResumo() {
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
        // ÍCONE ESQUERDA
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.auto_graph,
            color: Colors.white,
            size: 26,
          ),
        ),

        const SizedBox(width: 16),

        // TEXTOS
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Olá, Gustavo! 👋",
                style: TextStyle(
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

        // ÍCONE DIREITA
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
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

// Cards 