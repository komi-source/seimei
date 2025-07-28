import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SEIMEI/pages/splash_screen.dart';
import 'package:SEIMEI/firebase_options.dart';
import 'package:SEIMEI/themes/theme_provider.dart';

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
