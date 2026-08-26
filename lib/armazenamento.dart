import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Armazenamento {
  static Future<List<Map<String, dynamic>>> carregar() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getStringList('abastecimentos') ?? [];

    return dados
        .map(
          (e) => Map<String, dynamic>.from(
            jsonDecode(e),
          ),
        )
        .toList();
  }

  static Future<void> salvar(
    List<Map<String, dynamic>> dados,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      'abastecimentos',
      dados.map((e) => jsonEncode(e)).toList(),
    );
  }
}