import 'package:flutter/material.dart';
import 'package:flutter_cripto_coin/pages/favoritas_page.dart';
import 'package:flutter_cripto_coin/pages/moedas_page.dart';

import 'carteira_page.dart';
import 'configuracoes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,

        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const MoedasPage(),
          const FavoritasPage(),
          const CarteiraPage(),
          const ConfiguracoesPage(),
        ],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (pagina) {
          pc.animateToPage(
            pagina,
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        },
        currentIndex: paginaAtual,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todas',
          ),
          // ignore: prefer_const_constructors
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favoritas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Carteira',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Conta',
          ),
        ],
        backgroundColor: Colors.indigoAccent[50],
      ),
    );
  }
}
