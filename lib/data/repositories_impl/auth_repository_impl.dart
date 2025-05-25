// ignore_for_file: unused_import

import 'package:jigsaw_client/data/source/api_remote_datasource.dart';
import 'package:jigsaw_client/data/source/base_path_datasource.dart';
import 'package:jigsaw_client/domain/entities/session.dart';
import 'package:jigsaw_client/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  ApiRemoteDataSource apiRemoteDataSource;

  AuthRepositoryImpl({required this.apiRemoteDataSource});

  @override
  Future<bool> checkConnection(Uri uri) async {
    final bool isCorrect = await apiRemoteDataSource.checkConnection(uri);

    return isCorrect;
  }

  @override
  Future<Session> login(String username, String password) {
    return apiRemoteDataSource.login(username, password);
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }
}
