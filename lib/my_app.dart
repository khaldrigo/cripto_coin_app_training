import 'package:flutter/material.dart';
import 'package:flutter_cripto_coin/pages/moedas_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoedasBase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      // ignore: prefer_const_constructors
      home: MoedasPage(),
    );
  }
}
