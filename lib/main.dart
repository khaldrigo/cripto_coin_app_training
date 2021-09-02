import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cripto_coin/configs/app_settings.dart';
import 'package:flutter_cripto_coin/models/moedas.dart';
import 'package:flutter_cripto_coin/repositories/conta_repository.dart';
import 'package:flutter_cripto_coin/repositories/favoritas_repository.dart';
import 'package:flutter_cripto_coin/repositories/moeda_repository.dart';
import 'package:flutter_cripto_coin/services/auth_services.dart';
import 'package:provider/provider.dart';

import 'configs/hive_config.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => MoedaRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => ContaRepository(
            moedas: context.read<MoedaRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AppSettings(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoritasRepository(
            auth: context.read<AuthService>(),
            moedas: context.read<MoedaRepository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
