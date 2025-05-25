import 'package:jigsaw_client/domain/entities/session.dart';

abstract class AuthRepository {
  Future<Session> login(String username, String password);
  Future<void> logout();
  Future<bool> checkConnection(Uri uri);
}
