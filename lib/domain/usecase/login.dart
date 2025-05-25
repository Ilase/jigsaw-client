import 'package:jigsaw_client/domain/entities/session.dart';
import 'package:jigsaw_client/domain/repositories/auth_repository.dart';

class LoginUseCase {
  AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Session> call(String username, String password) async {
    return repository.login(username, password);
  }
}
