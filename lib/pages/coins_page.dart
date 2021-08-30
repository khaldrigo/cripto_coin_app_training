import 'package:flutter/material.dart';
import 'package:flutter_cripto_coin/models/coin.dart';
import 'package:flutter_cripto_coin/repositories/coin_repository.dart';
import 'package:intl/intl.dart';

class CoinsPage extends StatefulWidget {
  const CoinsPage({Key? key}) : super(key: key);

  @override
  State<CoinsPage> createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPage> {
  @override
  Widget build(BuildContext context) {
    final tabela = CoinRepository.tabela;
    NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
    List<Coin> selecionadas = [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Cripto Coins'),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int coin) {
          return ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            leading: SizedBox(
              child: Image.asset(tabela[coin].icone),
              width: 40,
            ),
            title: Text(
              tabela[coin].nome,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(real.format(tabela[coin].preco)),
            selected: selecionadas.contains(tabela[coin]),
            selectedTileColor: Colors.indigo[50],
            onTap: () {
              setState(() {
                (selecionadas.contains(tabela[coin]))
                    ? selecionadas.remove(tabela[coin])
                    : selecionadas.add(tabela[coin]);
              });
            },
          );
        },
        padding: EdgeInsets.all(16),
        separatorBuilder: (_, __) => Divider(),
        itemCount: tabela.length,
      ),
    );
  }
}
