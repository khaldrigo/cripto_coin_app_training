import 'package:flutter/material.dart';
import 'package:flutter_cripto_coin/configs/app_settings.dart';
import 'package:flutter_cripto_coin/repositories/conta_repository.dart';
import 'package:flutter_cripto_coin/repositories/favoritas_repository.dart';
import 'package:provider/provider.dart';

import 'configs/hive_config.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ContaRepository(),
        ),
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
