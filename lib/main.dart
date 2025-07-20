import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seimei_social_app/pages/splash_screen.dart';
import 'package:seimei_social_app/services/auth/auth_gate.dart';
import 'package:seimei_social_app/firebase_options.dart';
import 'package:seimei_social_app/themes/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // обязательно до инициализации Firebase

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
