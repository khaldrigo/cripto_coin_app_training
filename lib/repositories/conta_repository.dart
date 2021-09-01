import 'package:flutter/cupertino.dart';
import 'package:flutter_cripto_coin/database/db.dart';
import 'package:flutter_cripto_coin/models/historico.dart';
import 'package:flutter_cripto_coin/models/moedas.dart';
import 'package:flutter_cripto_coin/models/posicao.dart';
import 'package:flutter_cripto_coin/repositories/moeda_repository.dart';
import 'package:sqflite/sqflite.dart';

class ContaRepository extends ChangeNotifier {
  late Database db;
  List<Posicao> _carteira = [];
  List<Historico> _historico = [];
  double _saldo = 0;

  get saldo => _saldo;
  List<Posicao> get carteira => _carteira;
  List<Historico> get historico => _historico;

  ContaRepository() {
    _initRepository();
  }

  _initRepository() async {
    await _getSaldo();
    await _getCarteira();
    await _getHistorico();
  }

  _getSaldo() async {
    db = await DB.instance.database;
    List conta = await db.query('conta', limit: 1);
    _saldo = conta.first['saldo'];
    notifyListeners();
  }

  setSaldo(double valor) async {
    db = await DB.instance.database;
    db.update('conta', {
      'saldo': valor,
    });
    _saldo = valor;
    notifyListeners();
  }

  comprar(Moeda moeda, double valor) async {
    db = await DB.instance.database;
    await db.transaction((txn) async {
      //verificar se a moeda já foi comprada antes
      final posicaoMoeda = await txn.query(
        'carteira',
        where: 'sigla = ?',
        whereArgs: [moeda.sigla],
      );

      //Se não tem a moeda em carteira
      if (posicaoMoeda.isEmpty) {
        await txn.insert(
          'carteira',
          {
            'sigla': moeda.sigla,
            'moeda': moeda.nome,
            'quantidade': (valor / moeda.preco).toString()
          },
        );
      }
      // Já tem a determinada moeda em carteira e vai apenas adicionar mais
      else {
        final atual = double.parse(posicaoMoeda.first['quantidade'].toString());
        await txn.update(
          'carteira',
          {
            'quantidade': (atual + (valor / moeda.preco)).toString(),
          },
          where: 'sigla = ?',
          whereArgs: [moeda.sigla],
        );
      }

      // Inserir a compra no historico
      await txn.insert(
        'historico',
        {
          'sigla': moeda.sigla,
          'moeda': moeda.nome,
          'quantidade': (valor / moeda.preco).toString(),
          'valor': valor,
          'tipo_operacao': 'compra',
          'data_operacao': DateTime.now().millisecondsSinceEpoch,
        },
      );

      //Atualizar o saldo
      await txn.update('conta', {'saldo': saldo - valor});
    });

    await _initRepository();
    notifyListeners();
  }

  _getCarteira() async {
    _carteira = [];
    List posicoes = await db.query('carteira');
    posicoes.forEach((posicao) {
      Moeda moeda = MoedaRepository.tabela.firstWhere(
        (m) => m.sigla == posicao['sigla'],
      );
      _carteira.add(
        Posicao(
          moeda: moeda,
          quantidade: double.parse(posicao['quantidade']),
        ),
      );
    });
    notifyListeners();
  }

  _getHistorico() async {
    _historico = [];
    List operacoes = await db.query('historico');
    operacoes.forEach((operacao) {
      Moeda moeda = MoedaRepository.tabela.firstWhere(
        (m) => m.sigla == operacao['sigla'],
      );
      _historico.add(
        Historico(
          dataOperacao:
              DateTime.fromMillisecondsSinceEpoch(operacao['data_operacao']),
          tipoOperacao: operacao['tipo_operacao'],
          moeda: moeda,
          valor: operacao['valor'],
          quantidade: double.parse(operacao['quantidade']),
        ),
      );
    });
    notifyListeners();
  }
}
