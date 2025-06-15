import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/data/repositories_impl/auth_repository_impl.dart';
import 'package:jigsaw_client/data/source/api_remote_datasource.dart';
import 'package:jigsaw_client/ui/providers/dio_provider.dart';
import 'package:jigsaw_client/ui/providers/endpoints_provider.dart';

final apiRemoteDataSourceProvider = Provider((ref) {
  return ApiRemoteDataSource(
    dio: ref.watch(dioProvider),
    endpoints: ref.watch(endpointsProvider),
  );
});

final authRepositoryProvider = Provider((ref) {
  return AuthRepositoryImpl(ref.watch(apiRemoteDataSourceProvider));
});
