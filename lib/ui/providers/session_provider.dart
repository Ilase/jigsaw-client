import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/data/repositories_impl/auth_repository_impl.dart';
import 'package:jigsaw_client/domain/entities/session.dart';
import 'package:jigsaw_client/domain/repositories/auth_repository.dart';
import 'package:jigsaw_client/domain/usecase/login.dart';
import 'package:jigsaw_client/ui/providers/api_data_source_provider.dart';

class AuthNotifier extends StateNotifier<Session?> {
  AuthNotifier() : super(null);
}

final authRepositoryProvider = Provider((ref) {
  return AuthNotifier();
});

final loginUserProvider = Provider((ref) {
  return LoginUseCase(
    repository: AuthRepositoryImpl(
      apiRemoteDataSource: ref.watch(apiRemoteDataSourceProvider),
    ),
  );
});
