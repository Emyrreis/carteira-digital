import 'dart:convert';
import 'dart:io';

import 'package:carteira_core/carteira_core.dart';

/// [SessionStorage] do app: guarda a sessão como JSON num arquivo na pasta
/// do próprio app.
///
/// Dart puro (dart:io), sem plugin: funciona mesmo em PCs onde o Windows
/// não deixa ativar o Modo de Desenvolvedor.
class FileSessionStorage implements SessionStorage {
  FileSessionStorage({Directory? directory})
      : _file = File(
    '${(directory ?? _defaultDirectory()).path}'
        '${Platform.pathSeparator}carteira_session.json',
  );

  final File _file;

  /// No Android, `systemTemp` é a pasta de cache do app, que o sistema pode
  /// limpar sozinho (e deslogar o usuário). A pasta `files` ao lado dela é a
  /// pasta interna permanente do app. Nas outras plataformas, usa `systemTemp`.
  static Directory _defaultDirectory() {
    final temp = Directory.systemTemp;
    if (Platform.isAndroid) {
      return Directory('${temp.parent.path}${Platform.pathSeparator}files');
    }
    return temp;
  }

  @override
  Future<Session?> read() async {
    try {
      if (!await _file.exists()) return null;
      final raw = await _file.readAsString();
      return Session.fromJson(asJson(jsonDecode(raw)));
    } catch (_) {
      // Arquivo corrompido ou de outra versão: trata como "sem sessão".
      await clear();
      return null;
    }
  }

  @override
  Future<void> write(Session session) async {
    await _file.parent.create(recursive: true);
    await _file.writeAsString(jsonEncode(session.toJson()), flush: true);
  }

  @override
  Future<void> clear() async {
    try {
      if (await _file.exists()) await _file.delete();
    } catch (_) {
      // Nada a fazer: sem arquivo, sem sessão.
    }
  }
}