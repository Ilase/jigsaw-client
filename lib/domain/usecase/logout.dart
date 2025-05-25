import 'package:jigsaw_client/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<void> call() async {
    return repository.logout();
  }
}
