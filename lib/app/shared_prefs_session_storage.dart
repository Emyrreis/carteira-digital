import 'dart:convert';

import 'package:carteira_core/carteira_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [SessionStorage] do app: guarda a sessão como JSON numa chave do
/// shared_preferences (um dicionário chave → valor salvo no aparelho).
class SharedPrefsSessionStorage implements SessionStorage {
  static const _key = 'carteira.session';

  @override
  Future<Session?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      return Session.fromJson(asJson(jsonDecode(raw)));
    } catch (_) {
      // Dado corrompido ou de outra versão: trata como "sem sessão".
      await prefs.remove(_key);
      return null;
    }
  }

  @override
  Future<void> write(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(session.toJson()));
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
