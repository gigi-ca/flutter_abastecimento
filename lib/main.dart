import 'package:flutter/material.dart';
import 'splash.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool escuro = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abastecimentos',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 195, 255),
        ),
        scaffoldBackgroundColor:
            const Color(0xFFFFF8F2),
      ),

      darkTheme: ThemeData.dark(),

      themeMode: escuro
          ? ThemeMode.dark
          : ThemeMode.light,

      home: Splash(
        escuro: escuro,
        mudarTema: () {
          setState(() {
            escuro = !escuro;
          });
        },
      ),
    );
  }
}