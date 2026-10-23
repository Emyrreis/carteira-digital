import 'package:carteira_core/carteira_core.dart';
import 'package:flutter/foundation.dart';

import 'profile_coordinator.dart';
import 'server_profile.dart';

/// State and actions of the profile scene ("Perfil" tab).
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required this._serverProfile, required this._coordinator});

  final ServerProfile _serverProfile;
  final ProfileCoordinator _coordinator;

  User? _user;
  bool _isLoading = false;
  bool _isLoggingOut = false;
  String? _errorMessage;
  bool _disposed = false;

  bool get isLoading => _isLoading;
  bool get isLoggingOut => _isLoggingOut;
  String? get errorMessage => _errorMessage;
  String get name => _user?.name ?? '';
  String get email => _user?.email ?? '';
  String? get avatarUrl => _user?.avatarUrl;

  Future<void> start() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _serverProfile.fetchProfile();
    _isLoading = false;
    switch (result) {
      case Ok(:final value):
        _user = value;
        notifyListeners();
      case Failure(error: UnauthorizedError()):
        await logout();
      case Failure(:final error):
        _errorMessage = error.message;
        notifyListeners();
    }
  }

  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    notifyListeners();
    await _serverProfile.logout();
    _coordinator.goToLogin();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
