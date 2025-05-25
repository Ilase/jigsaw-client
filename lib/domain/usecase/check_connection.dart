import 'package:jigsaw_client/domain/repositories/auth_repository.dart';

class CheckConnectionUseCase {
  AuthRepository repository;
  CheckConnectionUseCase({required this.repository});
  Future<bool> call(Uri uri) async {
    return repository.checkConnection(uri);
  }
}
