import 'package:flutter/material.dart';
import 'package:flutter_cripto_coin/pages/coins_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BaseCoins',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: CoinsPage(),
    );
  }
}
