import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/data/repositories_impl/auth_repository_impl.dart';
import 'package:jigsaw_client/domain/repositories/auth_repository.dart';
import 'package:jigsaw_client/domain/usecase/check_connection.dart';
import 'package:jigsaw_client/ui/providers/api_data_source_provider.dart';

final checkConnectionProvider = Provider((ref) {
  return CheckConnectionUseCase(
    repository: AuthRepositoryImpl(ref.read(apiRemoteDataSourceProvider)),
  );
});
