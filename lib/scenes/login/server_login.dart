import 'package:carteira_core/carteira_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Authentication backend used by the login scene.
abstract interface class ServerLogin {
  Future<Result>fetchLogin({required String email, required String password});
}

/// Offline [ServerLogin] for development and previews.
class LoginMockServer implements ServerLogin {
  static const email = 'ana@carteira.dev';
  static const password = '123456';
  final Duration delay;

  const LoginMockServer({this.delay = const Duration(milliseconds: 2000)});

  @override
  Future<Result>fetchLogin({ required String email,  required String password,}) async {

    'if (email.isEmpty || password.isEmpty) {
      return const Failure(ValidationError({}, detail: 'Campos vazios'));
    }

    if (email != LoginMockServer.email || password != LoginMockServer.password) {
      return const Failure(ValidationError({}, detail: 'Email ou senha inválidos'));
    }
    return const Ok(true);
  }
}
/// Real [ServerLogin], talking to the Carteira API.
class LoginServer implements ServerLogin {
  // Emulador Android enxerga o PC em 10.0.2.2; Chrome/desktop usam localhost.
  static String baseUrl = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:8080'
      : 'http://localhost:8080';

  final ApiClient client;

  LoginServer({ApiClient? client})
      : client = client ?? ApiClient(baseUrl: LoginServer.baseUrl);

  @override
  Future<Result> fetchLogin({
    required String email,
    required String password,
  }) async {
    final result = await client.post(
      '/auth/login',
      body: {'email': email, 'password': password},
    );

    return switch (result) {
      Ok() => const Ok(true),
      Failure(:final error) => Failure(error),
    };
  }
}