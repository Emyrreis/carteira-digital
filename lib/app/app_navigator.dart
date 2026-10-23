import 'package:flutter/material.dart';

/// Chave do Navigator do app. Os coordinators usam ela para trocar de tela
/// sem precisar receber um BuildContext da View.
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

/// Substitui a pilha inteira pela [screen] (sem botão de voltar).
void replaceRoot(Widget screen) {
  appNavigatorKey.currentState?.pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => screen),
    (_) => false,
  );
}
