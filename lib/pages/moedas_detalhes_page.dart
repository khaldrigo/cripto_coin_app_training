import 'package:flutter/material.dart';
import 'package:flutter_cripto_coin/models/moedas.dart';

class MoedasDetalhesPage extends StatefulWidget {
  Moeda moeda;

  MoedasDetalhesPage({Key? key, required this.moeda}) : super(key: key);

  @override
  _MoedasDetalhesPageState createState() => _MoedasDetalhesPageState();
}

class _MoedasDetalhesPageState extends State<MoedasDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moeda.nome),
      ),
      body: Column(
        children: [
          const Divider(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 50,
                  child: Image.asset(widget.moeda.icone),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
