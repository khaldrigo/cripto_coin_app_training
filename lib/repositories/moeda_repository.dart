import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cripto_coin/database/db.dart';
import 'package:flutter_cripto_coin/models/moedas.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class MoedaRepository extends ChangeNotifier {
  List<Moeda> _tabela = [];
  List<Moeda> get tabela => _tabela;

  MoedaRepository() {
    _setupMoedasTable();
    _setupDadosTableMoeda();
    _readMoedasTable();
  }
  _readMoedasTable() async {
    Database db = await DB.instance.database;
    List resultados = await db.query('moedas');

    _tabela = resultados.map((row) {
      return Moeda(
        baseId: row['baseId'],
        icone: row['icone'],
        sigla: row['sigla'],
        nome: row['nome'],
        preco: double.parse(row['preco']),
        timestamp: DateTime.fromMillisecondsSinceEpoch(row['timestamp']),
        mudancaHora: double.parse(row['mudancaHora']),
        mudancaDia: double.parse(row['mudancaDia']),
        mudancaSemana: double.parse(row['mudancaSemana']),
        mudancaMes: double.parse(row['mudancaMes']),
        mudancaAno: double.parse(row['mudancaAno']),
        mudancaPeriodoTotal: double.parse(row['mudancaPeriodoTotal']),
      );
    }).toList();

    notifyListeners();
  }

  _moedasTableIsEmpty() async {
    Database db = await DB.instance.database;
    List resultados = await db.query('moedas');
    return resultados.isEmpty;
  }

  _setupDadosTableMoeda() async {
    if (await _moedasTableIsEmpty()) {
      String uri = 'https://api.coinbase.com/v2/assets/search?base=BRL';

      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> moedas = json['data'];
        Database db = await DB.instance.database;
        Batch batch = db.batch();

        moedas.forEach((moeda) {
          final preco = moeda['latest_price'];
          final timestamp = DateTime.parse(preco['timestamp']);

          batch.insert('moedas', {
            'baseId': moeda['id'],
            'sigla': moeda['symbol'],
            'nome': moeda['name'],
            'icone': moeda['image_url'],
            'preco': moeda['latest'],
            'timestamp': timestamp.millisecondsSinceEpoch,
            'mudancaHora': preco['percent_change']['hour'].toString(),
            'mudancaDia': preco['percent_change']['day'].toString(),
            'mudancaSemana': preco['percent_change']['week'].toString(),
            'mudancaMes': preco['percent_change']['month'].toString(),
            'mudancaAno': preco['percent_change']['year'].toString(),
            'mudancaPeriodoTotal': preco['percent_change']['all'].toString(),
          });
        });
        await batch.commit(noResult: true);
      }
    }
  }

  _setupMoedasTable() async {
    // ignore: prefer_const_declarations
    final String table = '''
      CREATE TABLE IF NOT EXISTS moedas (
        baseId TEXT PRIMARY KEY,
        sigla TEXT,
        nome TEXT,
        icone TEXT,
        preco TEXT,
        timestamp INTEGER,
        mudancaHora TEXT,
        mudancaDia TEXT,
        mudancaSemana TEXT,
        mudancaMes TEXT,
        mudancaAno TEXT,
        mudancaPeriodoTotal TEXT
      );
    ''';
    Database db = await DB.instance.database;
    await db.execute(table);
  }
}
