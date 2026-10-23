import 'package:carteira_core/carteira_core.dart';

/// [SessionStorage] em memória, usado no navegador (Chrome), onde dart:io
/// não funciona. A sessão se perde ao recarregar a página.
class MemorySessionStorage implements SessionStorage {
  Session? _session;

  @override
  Future<Session?> read() async => _session;

  @override
  Future<void> write(Session session) async {
    _session = session;
  }

  @override
  Future<void> clear() async {
    _session = null;
  }
}