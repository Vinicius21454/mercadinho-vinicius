import 'package:flutter/material.dart';
import 'home.dart';
import 'produtos_page.dart';
// import 'carrinho.dart';
// import 'estoque.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int paginaAtual = 0;

  final List<Widget> paginas = const [
    HomePage(),
    ProdutosPage(),
    // CarrinhoPage(),
    // EstoquePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: paginas[paginaAtual],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),

        onTap: (index) {
          setState(() => paginaAtual = index);
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: "Produtos",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Carrinho",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Estoque",
          ),
        ],
      ),
    );
  }
}
