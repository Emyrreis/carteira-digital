import '../../app/app_navigator.dart';
import '../login/login_factory.dart';

/// Navigation out of the profile scene.
abstract interface class ProfileCoordinator {
  void goToLogin();
}

class DefaultProfileCoordinator implements ProfileCoordinator {
  @override
  void goToLogin() => replaceRoot(LoginFactory.make());
}
