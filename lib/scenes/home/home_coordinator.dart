import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';
import '../login/login_factory.dart';

/// Navigation out of the home scene.
abstract interface class HomeCoordinator {
  /// Session ended or expired.
  void goToLogin();

  /// "+" button. The new-transaction scene does not exist yet.
  void goToNewTransaction();
}

class DefaultHomeCoordinator implements HomeCoordinator {
  @override
  void goToLogin() => replaceRoot(LoginFactory.make());

  @override
  void goToNewTransaction() {
    final context = appNavigatorKey.currentContext;
    if (context == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Novo lançamento: em breve')),
    );
  }
}
