import 'package:flutter/material.dart';
import 'package:flutter_cripto_coin/configs/app_settings.dart';
import 'package:flutter_cripto_coin/repositories/favoritas_repository.dart';
import 'package:provider/provider.dart';

import 'my_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppSettings(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoritasRepository(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
