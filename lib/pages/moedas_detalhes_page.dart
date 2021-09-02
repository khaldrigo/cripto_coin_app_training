import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cripto_coin/models/moedas.dart';
import 'package:flutter_cripto_coin/repositories/conta_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MoedasDetalhesPage extends StatefulWidget {
  Moeda moeda;

  MoedasDetalhesPage({Key? key, required this.moeda}) : super(key: key);

  @override
  _MoedasDetalhesPageState createState() => _MoedasDetalhesPageState();
}

class _MoedasDetalhesPageState extends State<MoedasDetalhesPage> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final _form = GlobalKey<FormState>();
  final _valor = TextEditingController();
  double quantidade = 0;
  late ContaRepository conta;

  comprar() async {
    if (_form.currentState!.validate()) {
      // Salvar a compra
      await conta.comprar(widget.moeda, double.parse(_valor.text));
      Navigator.pop(context);
      // ignore: prefer_const_constructors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Compra realizada com sucesso!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    conta = Provider.of<ContaRepository>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moeda.nome),
      ),
      body: Column(
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  widget.moeda.icone,
                  scale: 2.5,
                ),
                Container(
                  width: 10,
                ),
                Text(
                  real.format(
                    widget.moeda.preco,
                  ),
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                      color: Colors.grey[800]),
                ),
              ],
            ),
          ),
          (quantidade > 0)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // ignore: avoid_unnecessary_containers
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      child: Text(
                        '${quantidade.toStringAsFixed(2)} ${widget.moeda.sigla}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.teal,
                        ),
                      ),
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.05),
                      ),
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(bottom: 24),
                ),
          Form(
            key: _form,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                controller: _valor,
                style: const TextStyle(
                  fontSize: 22,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Valor',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  suffix: Text(
                    'reais',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o valor da compra!';
                  } else if (double.parse(value) < 50) {
                    return 'Compra mínima é de R\$50,00';
                  } else if (double.parse(value) > conta.saldo) {
                    return 'Você não tem saldo suficiente para essa compra!';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    quantidade = (value.isEmpty)
                        ? 0
                        : double.parse(value) / widget.moeda.preco;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: comprar,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Icon(Icons.check),
                    // ignore: prefer_const_constructors
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Comprar!',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
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
